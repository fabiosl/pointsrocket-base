# == Schema Information
#
# Table name: hashtag_challenge_users
#
#  id                   :integer          not null, primary key
#  hashtag_challenge_id :integer
#  status               :string(255)
#  url                  :string(255)
#  json                 :text
#  social_id            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  feedback             :text
#

FactoryGirl.define do
  factory :hashtag_challenge_user do
    hashtag_challenge
    status "approved"
    url "MyString"
    json "MyText"
    social_id "MyString"
    user
  end

end