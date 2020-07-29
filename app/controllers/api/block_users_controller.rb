module Api
  class BlockUsersController < Api::BaseController
    include BlockUsersHelper
    include ControllerApiDomainHelper

    private
      def must_notify?
        false
      end

      def block_user_params
        the_params = params.require(:block_user).permit(
          @@permitted_params
        )
        the_params.merge!(blocker_id: current_user.id)
        the_params
      end
  end
end
