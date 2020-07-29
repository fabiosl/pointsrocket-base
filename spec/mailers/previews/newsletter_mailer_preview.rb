# Preview all emails at http://localhost:3000/rails/mailers/newsletter_mailer
class NewsletterMailerPreview < ActionMailer::Preview

  def new_newsletter_email
    start_date = 100.days.ago
    end_date = Time.zone.now
    user = User.last
    domain = Domain.get_current_domain

    NewsletterMailer.new_newsletter_email(start_date, end_date, user, domain)
  end
end
