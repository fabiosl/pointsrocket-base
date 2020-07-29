class BadgeUserMailer < AppMailer
  def new_badge_email(domain, user, badge_user)
    @domain = domain
    @user = user
    @badge_user = badge_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']
    with_user_locale do
      mail(
        to: user.email,
        from: from_mail,
        subject: "#{I18n.t('models.badges.new_badge_earned')} [#{@badge_user.badge.name}] - #{@domain.name}"
      )
    end
  end
end
