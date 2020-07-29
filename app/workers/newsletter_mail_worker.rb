class NewsletterMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(start_date_str, end_date_str, user_id, subdomain)
    domain = Domain.find_by(subdomain: subdomain)
    start_date = Time.zone.parse(start_date_str)
    end_date = Time.zone.parse(end_date_str)

    Apartment::Tenant.switch(subdomain) do
      user = User.find(user_id)

      return if not user.email.present?

      NewsletterMailer.new_newsletter_email(
        start_date, end_date, user, domain
      ).deliver if user.subscribe
    end
  end
end
