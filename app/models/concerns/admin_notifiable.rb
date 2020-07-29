module AdminNotifiable
  extend ActiveSupport::Concern

  included do
    after_create :mail_admin_users
  end

  def mail_admin_users
    # if not Rails.env.test?
    worker = "#{self.class}MailWorker".constantize
    domain = Domain.get_current_domain

    if domain.present?
      User.admin.each do |user|
        worker.perform_async(domain.id, user.id, id)
        user.devices.ios.push_notification_active.each do |device|
          AdminIosPushNotificationWorker.perform_async(
            Apartment::Tenant.current,
            self.class,
            id,
            device.id
          )
        end

        user.devices.android.push_notification_active.each do |device|
          AdminAndroidPushNotificationWorker.perform_async(
            Apartment::Tenant.current,
            self.class,
            id,
            device.id
          )
        end
      end
      # else
      #   User.admin.domain(domain).each do |user|
      #     worker.perform_async(domain.id, user.id, id)
      #   end
      # end
    end

  end
end
