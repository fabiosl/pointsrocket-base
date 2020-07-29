class AddPushNotificationActiveToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :push_notification_active, :boolean, default: true
  end
end
