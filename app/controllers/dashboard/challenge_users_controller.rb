class Dashboard::ChallengeUsersController < DashboardController
  before_action :set_challenge
  before_action :set_challenge_users
  before_action :set_challenge_user, only: [:update, :destroy]

  def update
    authorize! :update, @challenge_user

    if @challenge_user.update(challenge_user_params)
      flash[:success] = t ".success"
      redirect_to challenge_path(@challenge)
    else
      @show_submission_modal = true
      @current_user_submissions = @challenge.challenge_users.where(user: current_user)
      render "dashboard/challenges/show"
    end
  end

  def destroy
    authorize! :destroy, @challenge_user
    @challenge_user.destroy
    flash[:success] = t ".success"
    redirect_to challenge_path(@challenge)

  end

  def create
    @challenge_user = @challenge.challenge_users.new(
      challenge_user_params(status: "pending").merge({
        check_terms: true,
        user: current_user,
      })
    )

    if @challenge_user.save
      flash[:success] = t ".success"
      redirect_to challenge_path(@challenge)
    else
      @show_submission_modal = true
      @current_user_submissions = @challenge.challenge_users.where(user: current_user)
      render "dashboard/challenges/show"
    end
  end

  private

    def set_challenge_user
      @challenge_user = @challenge.challenge_users.find params[:id]
    end

    def set_challenge
      @challenge = Challenge.find params[:challenge_id]
    end

    def set_challenge_users
      @challenge_users = @challenge.challenge_users.visible
    end

    def challenge_user_params(default={})
      params.require(:challenge_user).permit(
        [:url, :description, :file, :accept_terms]
      ).merge(
        challenge_id: params[:challenge_id]
      ).merge(
        default
      )

    end

end
