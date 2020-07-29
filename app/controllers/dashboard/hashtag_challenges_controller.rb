class Dashboard::HashtagChallengesController < DashboardController
  before_action :set_hashtag_challenges
  before_action :set_hashtag_challenge, only: :show

  def index

  end

  def show
    @show_submission_created = params['submissao_criada'] == 'ok'
    @show_modal_nao_aceita_id = params['nao-aceita']
    @hashtag_challenge_user = @hashtag_challenge.hashtag_challenge_users.new
    @hashtag_challenge_users = @hashtag_challenge.hashtag_challenge_users.where.not(
      user_id: current_user.block_users.pluck(:blocked_id)).visible
    @current_user_submissions = @hashtag_challenge.hashtag_challenge_users.where(user: current_user)
  end

  private

    def set_hashtag_challenges
      @hashtag_challenges = HashtagChallenge.all
    end

    def set_hashtag_challenge
      @hashtag_challenge = @hashtag_challenges.find params[:id]
    end

end
