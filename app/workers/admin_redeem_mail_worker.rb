class AdminRedeemMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(tenant, user_id, campaign_user_id)

    Apartment::Tenant.switch(tenant) do
      domain = Domain.get_current_domain
      campaign_user = CampaignUser.find(campaign_user_id)
      user = User.find(user_id)

      CampaignUserMailer.new_campaign_user_email_to_admin_user(
        domain, user, campaign_user
      ).deliver
    end
  end
end
