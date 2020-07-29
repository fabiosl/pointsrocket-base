class AccessTokenMailer < AppMailer

  def expired(user, domain)
    @user = user
    @domain = domain
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{t('access_token_mailer.expired.subject')} - #{@domain.name}"
      )
    end
  end
end
