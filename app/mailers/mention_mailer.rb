class MentionMailer < AppMailer

  def new_mention_email(domain, user, mentionable)
    @domain = domain
    @user = user
    @mentionable = mentionable
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    base_url = "#{@domain.get_url}/dashboard"
    
    if mentionable.class == Answer
      @see_more_url = "#{base_url}/perguntas/#{@mentionable.question.id}"
    else
      @see_more_url = "#{base_url}/timeline"
    end

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.comments.new_mention')} - #{@domain.name}"
      )
    end
  end
end
