# == Schema Information
#
# Table name: employee_advocacy_shares
#
#  id                        :integer          not null, primary key
#  employee_advocacy_post_id :integer
#  user_id                   :integer
#  social_network            :string(255)
#  user_content              :text
#  schedule_date             :datetime
#  shared_date               :datetime
#  token                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  social_json               :text
#  post_json                 :text
#  where_to_publish          :string(255)
#

FactoryGirl.define do
  factory :employee_advocacy_share do
    employee_advocacy_post
    user
    social_network "acebook"
    user_content "MyText"
    schedule_date "2016-07-06 15:41:35"
    shared_date "2016-07-06 15:41:35"
    token { FFaker::Lorem.characters(10) }
  end

end
