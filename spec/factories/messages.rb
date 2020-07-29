# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  body            :text
#  conversation_id :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  read_at         :datetime
#

FactoryGirl.define do
  factory :message do
    body "My Message"
    user
    conversation
    read_at nil

    trait :without_body do
      body ""
    end

  end
end
