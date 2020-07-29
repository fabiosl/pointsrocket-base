class PeerRecognitionPointsMailer < AppMailer
  def new_peer_recognition_points_email(domain, user)
    @domain = domain
    @user = user

    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('mailers.peer_recognition_points.new_points_subject')} - #{@domain.name}"
      ) if send_domain_user_email?(domain, user)
    end
  end

  def expiration_peer_recognition_points_email(domain, user)
    @domain = domain
    @user = user

    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('mailers.peer_recognition_points.will_expire')} - #{@domain.name}"
      ) if send_domain_user_email?(domain, user) && @user.available_coins > 0
    end
  end

  private

  def send_domain_user_email?(domain, user)
    domain.peer_recognition_enabled? && user.subscribe
  end
end
