class CommentMailer < AppMailer
  def new_comment_email(domain, user, comment)
    @domain = domain
    @user = user
    @comment = comment.decorate
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.comments.new')} - #{@domain.name}"
      )
    end
  end
end
