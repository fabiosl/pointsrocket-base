module Api
  class CampaignsController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def index
      @campaigns = resource_class.all
    end

    def create
      super
      @campaign.save

      check_campaign_badge
    end

    def update
      super
      check_campaign_badge
    end

    private

    def check_campaign_badge
      User.all.not_admin.each do |user|
        if @campaign.has_complete_campaign?(user) and @campaign.campaign_badges.any?
          if not user.has_complete_campaign(@campaign)
            user.campaigns << @campaign
            user.save
          end
        else
          if user.has_complete_campaign(@campaign)
            user.campaign_users.where(campaign: @campaign).destroy_all
          end
        end
      end
    end

    def campaign_params
      the_params = params.require(:campaign).permit(
        :id,
        :title,
        :subtitle,
        :description,
        :start_date,
        :end_date,
        :image,
        :redeem_points,
        :max_redeems,
        :campaign_badges_attributes => [
          :id,
          :_destroy,
          :badge_id,
        ]
      )

      the_params
    end

    def query_params
      params.permit(:email)
    end
  end
end
