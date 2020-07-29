class AnswerMailer < AppMailer
  def new_answer_email(domain, user, answer)
    @domain = domain
    @user = user
    @answer = answer
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.questions.new_answer')} - #{@domain.name}"
      )
    end
  end
end
