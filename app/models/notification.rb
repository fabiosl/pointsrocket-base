# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  actor_id        :integer
#  action          :string(255)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  read_at         :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Notification < ActiveRecord::Base
  belongs_to :actor, class_name: "User"
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :for_user, -> (user) {
    # ransack({user_id_equals: user.id, user_id_equals: nil,  m: 'or'})
    where(user_id: [nil, user.id])
  }

  scope :unread, -> { where(read_at: nil) }

  after_create :emit_notification

  def emit_notification
    data = Rabl::Renderer.new(
      'api/notifications/_notification',
      self,
      { :view_path => 'app/views' }
    ).render

    parsed_data = JSON.parse(data)

    if recipient.present?
      recipient.devices.ios.push_notification_active.each do |device|
        if Rails.env.development? && ENV['DEV_NOTIFICATIONS_ENABLED'] == 'true'
          begin
            IosPushNotificationWorker.new.perform Apartment::Tenant.current, self.id, device.id
          rescue Exception => e
            ap e.message
            ap e.backtrace
          end
        else
          IosPushNotificationWorker.perform_async Apartment::Tenant.current, self.id, device.id
        end
      end

      recipient.devices.android.push_notification_active.each do |device|
        if Rails.env.development? && ENV['DEV_NOTIFICATIONS_ENABLED'] == 'true'
          begin
            AndroidPushNotificationWorker.new.perform Apartment::Tenant.current, self.id, device.id
          rescue Exception => e
            ap e.message
            ap e.backtrace
          end
        else
          AndroidPushNotificationWorker.perform_async Apartment::Tenant.current, self.id, device.id
        end
      end

      if Rails.env.development?
        if ENV['DEV_NOTIFICATIONS_ENABLED'] == 'true'
          EmitClient.new('notification_create', recipient.id, parsed_data).emit
        end
      else
        EmitClient.new('notification_create', recipient.id, parsed_data).emit
      end
    end

  end

  def notification_type
    "#{notifiable_type}_#{action}"
  end
end
