# == Schema Information
#
# Table name: notification_reads
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  notification_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class NotificationRead < ActiveRecord::Base
  belongs_to :recipient, class_name: 'User'
  belongs_to :notification, inverse_of: :notification_reads
end
