module Api
  class CampaignUsersController < Api::BaseController
    include CampaignUsersHelper
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def new_resource_with_params
      @campaign_user = current_user.campaign_users.new(campaign_user_params)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_resource(resource = nil)
      resource ||= current_user.campaign_users.find(params[:id])
      instance_variable_set("@#{resource_name}", resource)
    end

    def campaign_user_params
      the_params = params.require(:campaign_user).permit(
        :id,
        :campaign_id,
      )

      the_params
    end

  end
end
