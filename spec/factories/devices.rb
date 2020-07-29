# == Schema Information
#
# Table name: devices
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  device_type              :string(255)
#  push_notification_token  :string(255)
#  device_id                :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  push_notification_active :boolean          default(TRUE)
#  name                     :string(255)
#

FactoryGirl.define do
  factory :device do
    user
    push_notification_token "push_notification_token"
    device_id "device_id"
    push_notification_active true
    name "name"

    trait :ios do
      device_type "ios"
    end
  end

end
