class QuestionMailer < AppMailer
  def new_question_email(domain, user, question)
    @domain = domain
    @user = user
    @question = question
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.questions.new')} - #{@domain.name}"
      )
    end
  end
end
