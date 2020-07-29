class EmployeeAdvocacyMailer < AppMailer
  include Rails.application.routes.url_helpers
  
  layout nil

  def new_post_email user, employee_advocacy_post, domain
    @user = user
    @employee_advocacy_post = employee_advocacy_post
    @domain = domain
    @employee_advocacy_url = "#{@domain.get_url}#{employee_advocacy_path}"
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.employee_advocacy_posts.title')} - #{@domain.name}"
      )
    end

  end
end
