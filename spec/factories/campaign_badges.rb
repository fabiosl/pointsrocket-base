# == Schema Information
#
# Table name: campaign_badges
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  badge_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

FactoryGirl.define do
  factory :campaign_badge do
    campaign nil
badge nil
  end

end
