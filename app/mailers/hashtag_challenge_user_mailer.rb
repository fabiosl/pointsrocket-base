class HashtagChallengeUserMailer < AppMailer
  def new_publication_on_hashtag(domain, hashtag_challenge_user)
    @domain = domain
    @hashtag_challenge_user = hashtag_challenge_user.decorate
    @user = hashtag_challenge_user.user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{t('.subject')} - #{@domain.name}"
      )
    end
  end

  def new_hashtag_challenge_user_email(domain, user, hashtag_challenge_user)
    @domain = domain
    @user = user
    @hashtag_challenge_user = hashtag_challenge_user.decorate
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.hashtag_challenge_user.new')} - #{@domain.name}"
      )
    end
  end
end
