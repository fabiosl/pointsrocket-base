class CampaignUserMailer < AppMailer
  def new_campaign_user_email(domain, user, campaign_user)
    @domain = domain
    @user = user
    @campaign_user = campaign_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']
    if @campaign_user.campaign.is_redeemable?
      key = "models.campaign_user.new_redeem"
    else
      key = "models.campaign_user.new"
    end

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t(key)} - #{@domain.name}"
      )
    end
  end

  def new_campaign_user_email_to_user(domain, user, campaign_user)
    @domain = domain
    @user = user
    @campaign_user = campaign_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t("models.campaign_user.you_redeemed_a_reward")} - #{@domain.name}"
      )
    end
  end

  def new_campaign_user_email_to_admin_user(domain, user, campaign_user)
    @domain = domain
    @user = user
    @campaign_user = campaign_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t("models.campaign_user.user_redeemed_a_reward")} - #{@domain.name}"
      )
    end
  end
end
