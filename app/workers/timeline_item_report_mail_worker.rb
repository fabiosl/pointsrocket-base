class TimelineItemReportMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, timeline_item_id, report_type, report_description, report_user_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      timeline_item = TimelineItem.find(timeline_item_id)
      report_user = User.find(report_user_id)
      
      TimelineItemReportMailer.new_content_report_email(
        domain, user, timeline_item, report_type, report_description, report_user
      ).deliver
    end
  end
end
