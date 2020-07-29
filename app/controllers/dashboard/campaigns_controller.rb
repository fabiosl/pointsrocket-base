class Dashboard::CampaignsController < DashboardController
  before_action :set_campaigns
  before_action :set_campaign, only: :show

  def index
    authorize! :campaigns, current_user
  end

  def prizes
    authorize! :campaigns, current_user
  end

  def show
    authorize! :campaigns, current_user
  end

  private

    def set_campaigns
      @campaigns = Campaign.all
    end

    def set_campaign
      @campaign = @campaigns.find params[:id]
    end
end
