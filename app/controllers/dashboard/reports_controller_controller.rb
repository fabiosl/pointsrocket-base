class Dashboard::ReportsControllerController < DashboardController
  def create
    
  end


  private

  def mail_admin_users
    unless Rails.env.test?
      domain = Domain.find_by(subdomain: Apartment::Tenant.current)

      if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
        User.admin.each do |user|
          TimelineItemReportWorker.perform_async(domain.id, user.id, id)
        end
      else
        User.admin.domain(domain).each do |user|
          TimelineItemReportWorker.perform_async(domain.id, user.id, id)
        end
      end
    end
  end
end
