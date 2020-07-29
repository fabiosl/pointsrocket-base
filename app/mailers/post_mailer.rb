class PostMailer < AppMailer

  def new_post_email(domain, user, post)
    @domain = domain
    @user = user
    @post = post.decorate
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: user.email,
        from: from_mail,
        subject: "#{I18n.t('models.posts.new')} - #{@domain.name}"
      )
    end
  end
end
