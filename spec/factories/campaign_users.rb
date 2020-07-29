# == Schema Information
#
# Table name: campaign_users
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :campaign_user do
    campaign nil
user nil
  end

end
