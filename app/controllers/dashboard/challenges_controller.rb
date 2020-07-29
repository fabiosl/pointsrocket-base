class Dashboard::ChallengesController < DashboardController
  before_action :set_challenges
  before_action :set_challenge, only: :show

  def index

  end

  def show
    @show_submission_created = params['submissao_criada'] == 'ok'
    @show_modal_nao_aceita_id = params['nao-aceita']
    @challenge_user = @challenge.challenge_users.new
    @challenge_users = @challenge.challenge_users.where.not(
      user_id: current_user.block_users.pluck(:blocked_id)).visible
    @challenge_users_groups = challenge_users_groups(@challenge_users)
    @current_user_submissions = @challenge.challenge_users.where(user: current_user)
  end

  private

    def set_challenges
      @challenges = Challenge.all.order("date_end desc")
    end

    def set_challenge
      @challenge = @challenges.find params[:id]
    end

    def challenge_users_groups(challenge_users)
      total = challenge_users.count
      total_groups = 2
      counter = 0
      groups = challenge_users.order("created_at desc")
                              .decorate
                              .sort_by { |challenge_user| challenge_user.user_id == current_user.id ? 0 : 1 }
                              .inject([]) do |memo, challenge_user|
        group_index = counter.to_f % total_groups

        memo[group_index] ||= []
        memo[group_index] << challenge_user
        counter += 1
        memo
      end
    end
end
