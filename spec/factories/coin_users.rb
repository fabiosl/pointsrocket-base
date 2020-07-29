# == Schema Information
#
# Table name: coin_users
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  points       :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  content      :text
#  coin_give_id :integer
#  hashtags     :text             default([]), is an Array
#

FactoryGirl.define do
  factory :coin_user do
    sender_id 1
recipient_id 1
points 1
  end

end
