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

class CampaignBadge < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :badge

  accepts_nested_attributes_for :campaign
  accepts_nested_attributes_for :badge
end
