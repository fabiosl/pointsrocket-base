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

FactoryGirl.define do
  factory :notification do
    recipient nil
    sender nil
    message "MyString"
    link "MyString"
    notificable nil
    to_all false
  end
end
