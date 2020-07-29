class DailyReportMailer < AppMailer
  default from: "from@example.com"

  def new_daily_report_email(domain)
    email_data(domain)
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']
    with_user_locale do
      mail(
        to: user.email,
        from: from_mail,
        subject: "Daily Report - #{domain.name}"
      )
    end
  end

  private

  def email_data(domain)
    datetime = 1.day.ago
    @domain = domain
    @posts = Post.where("created_at <= ?", datetime)
    @challenge_submissions = ChallengeUser.where("created_at <= ?", datetime)
    @hashtag_challenge_submissions = HashtagChallengeUser.where("created_at <= ?", datetime)
  end
end
