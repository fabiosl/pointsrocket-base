# Preview all emails at http://localhost:3000/rails/mailers/campaign_user_mailer
class CampaignUserMailerPreview < ActionMailer::Preview

  def new_campaign_user_email
    domain = Domain.get_current_domain
    campaign_user = CampaignUser.last
    user = campaign_user.user
    CampaignUserMailer.new_campaign_user_email(domain, user, campaign_user)
  end

  def new_campaign_user_email_to_user
    domain = Domain.get_current_domain
    campaign_user = CampaignUser.last
    user = campaign_user.user
    CampaignUserMailer.new_campaign_user_email_to_user(domain, user, campaign_user)
  end

  def new_campaign_user_email_to_admin_user
    domain = Domain.get_current_domain
    campaign_user = CampaignUser.last
    user = User.find_by(admin: true)
    CampaignUserMailer.new_campaign_user_email_to_admin_user(domain, user, campaign_user)
  end

end
