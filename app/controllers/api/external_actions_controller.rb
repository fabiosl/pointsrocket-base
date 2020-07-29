module Api
  class ExternalActionsController < Api::BaseController

    skip_before_action :verify_authenticity_token

    def create
      super
      if @external_action
        @external_action.domain = @domain
        ExternalActionFlow.new(@external_action).run
      end
    end

    private

    def external_action_params
      the_params = {
        text: params[:text]
      }

      # the_params = params.require(:external_action).permit(
      #   :id,
      #   :text
      # )

      the_params
    end

    def query_params
      params.permit(:email)
    end
  end
end
