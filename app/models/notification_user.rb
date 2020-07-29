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

class NotificationUser < ActiveRecord::Base
  belongs_to :notification, inverse_of: :notification_users
  belongs_to :user
end
