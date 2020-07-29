class CampaignUserMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, campaign_user_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      campaign_user = CampaignUser.find(campaign_user_id)

      CampaignUserMailer.new_campaign_user_email(
        domain, user, campaign_user
      ).deliver if user.subscribe
    end
  end
end
