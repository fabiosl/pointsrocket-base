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

class CampaignUser < ActiveRecord::Base
  include AdminNotifiable

  belongs_to :campaign
  belongs_to :user

  act_as_pointable

  act_as_timelineable type: :user, update_relations: [:campaign]

  has_many :comments, as: :commentable, dependent: :destroy

  after_update :remove_points, if: :must_remove_points
  after_create :remove_points, if: :must_remove_points
  after_create :notify_user_email

  def notify_user_email
    if campaign.is_redeemable?
      RedeemMailWorker.perform_async Apartment::Tenant.current, self.id
    end
  end

  def must_remove_points
    campaign.present? and campaign.is_redeemable?
  end

  def remove_points
    if user
      r = user._add_points pointable: self, value: -campaign.redeem_points
    end
  end
end
