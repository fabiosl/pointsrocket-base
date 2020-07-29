# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :conversation do
    sequence :sender_id do |n|
      n
    end
    sequence :recipient_id do |n|
      n + 1
    end
  end

  trait :without_users do
    sender_id nil
    recipient_id nil
  end
end
