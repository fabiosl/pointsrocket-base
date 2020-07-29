class DailyReportMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default

  def perform
    domains = Domain.all

    domains.each do |domain|
      Apartment::Tenant.switch(domain.subdomain) do
        DailyReportMailer.new_daily_report_email(domain)
      end
    end
  end
end
