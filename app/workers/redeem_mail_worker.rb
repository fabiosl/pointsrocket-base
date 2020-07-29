class RedeemMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(tenant, campaign_user_id)

    Apartment::Tenant.switch(tenant) do
      domain = Domain.get_current_domain
      campaign_user = CampaignUser.find(campaign_user_id)
      user = campaign_user.user

      CampaignUserMailer.new_campaign_user_email_to_user(
        domain, user, campaign_user
      ).deliver

      mail_admin_users(domain, campaign_user)
    end
  end

  private

  def mail_admin_users(domain, campaign_user)
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      users = User.all.admin
    else
      users = User.domain(Domain.get_current_domain).admin
    end

    users.each do |user|
      AdminRedeemMailWorker.perform_async(domain.subdomain, user.id, campaign_user.id)
    end
  end
end
