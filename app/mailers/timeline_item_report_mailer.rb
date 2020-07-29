class TimelineItemReportMailer < AppMailer
  def new_content_report_email(domain, user, timeline_item, report_type, report_description, report_user)
    @domain = domain
    @user = user
    @timeline_item = timeline_item
    @report_type = report_type
    @report_description = report_description
    @report_user = report_user
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('views.mail.timeline_item_report.new')} - #{@domain.name}"
      )
    end
  end
end
