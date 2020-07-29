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

FactoryGirl.define do
  factory :notification_read do
    recipient nil
notification nil
  end

end
