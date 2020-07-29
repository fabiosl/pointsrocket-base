module Api
  class VotesController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def update
      authorize! :update, get_resource
      super
    end

    def destroy
      authorize! :destroy, get_resource
      super
    end

    private

      def vote_params
        vote_params = params.require(:vote).permit(:voteable_id, :voteable_type, :status)
        vote_params.merge!(user_id: current_user.id)
        vote_params
      end

      def query_params
        {}
      end
  end
end
