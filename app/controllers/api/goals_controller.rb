module Api
  class GoalsController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token
    #before_action :set_domain

    def index
      @goals = Goal.all.order('id desc')
    end

    def create
      super
      @goal.save
    end

    private

      def goal_params
        the_params = params.require(:goal).permit(
          :id,
          :title,
          :badge_goals_attributes => [
            :id,
            :badge_id,
            :repetition,
            :_destroy
          ]
        )

        the_params
      end

      def query_params
        params.permit(:email)
      end

      def set_domain
        @domain = Domain.find params[:domain_id]
      end

  end
end
