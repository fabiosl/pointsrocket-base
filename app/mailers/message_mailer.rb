class MessageMailer < AppMailer

  def new_message_email(domain, user, message)
    @domain = domain
    @user = user
    @message = message
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.messages.new')} - #{@domain.name}"
      )
    end

  end
end
