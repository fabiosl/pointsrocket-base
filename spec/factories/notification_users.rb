# == Schema Information
#
# Table name: notification_users
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  user_id         :integer
#  is_read         :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
  factory :notification_user do
    notification nil
    user nil
    is_read false
  end

end
