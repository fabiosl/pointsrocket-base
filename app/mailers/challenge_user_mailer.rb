class ChallengeUserMailer < AppMailer
  def new_challenge_user_email(domain, user, challenge_user)
    @domain = domain
    @user = user
    @challenge_user = challenge_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.challenge_user.new')} - #{@domain.name}"
      )
    end
  end

  def challenge_user_approved_email(domain, user, challenge_user)
    @domain = domain
    @user = user
    @challenge_user = challenge_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.challenge_user.approved')} - #{@domain.name}"
      )
    end 
  end
end
