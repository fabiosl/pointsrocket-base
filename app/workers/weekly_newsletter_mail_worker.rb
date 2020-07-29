class WeeklyNewsletterMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform
    start_date = 7.days.ago
    end_date = Time.zone.now

    Apartment.tenant_names.select(&:present?).each do |tenant|
      Apartment::Tenant.switch(tenant) do
        User.where(subscribe: true).each do |user|
          send_user_newletter(start_date, end_date, user, tenant)
        end
      end
    end
  end

  private

  def send_user_newletter(start_date, end_date, user, subdomain)
    NewsletterMailWorker.perform_async(
      start_date.to_s, end_date.to_s, user.id, subdomain
    )
  end
end
