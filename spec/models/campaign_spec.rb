# == Schema Information
#
# Table name: campaigns
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  description         :text
#  start_date          :datetime
#  end_date            :datetime
#  slug                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  redeem_points       :integer
#  max_redeems         :integer
#  withdrawable_points :integer          default(0)
#  subtitle            :string(255)      default("")
#

require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let(:user) { create(:user) }

  let(:badge_1) { create(:badge) }
  let(:badge_2) { create(:badge) }

  let(:campaign) { create(:campaign) }

  let(:campaign_badge_1) { create(:campaign_badge, campaign: campaign, badge: badge_1) }
  let(:campaign_badge_2) { create(:campaign_badge, campaign: campaign, badge: badge_2) }

  describe "has_complete_campaign?" do
    before do
      campaign
      campaign_badge_1
      campaign_badge_2
    end

    context "with badges" do
      before do
        create(:badge_user, user: user, badge: badge_1)
        create(:badge_user, user: user, badge: badge_2)
      end

      it "has completed campaign" do
        expect(campaign.has_complete_campaign?(user)).to be_truthy
      end
    end

    context "without badges" do
      it "hasn`t completed campaign" do
        expect(campaign.has_complete_campaign?(user)).to be_falsey
      end
    end

    context "without some badges" do
      before do
        create(:badge_user, user: user, badge: badge_1)
      end

      it "hasn`t completed campaign" do
        expect(campaign.has_complete_campaign?(user)).to be_falsey
      end
    end
  end

  describe "User.add_badge" do
    context "adding some campaigns badges" do

      before do
        campaign_badge_1
        campaign_badge_2
        user.add_badge(badge_1)
      end

      it "not add campaign" do
        expect(user.has_complete_campaign(campaign)).to be_falsey
      end
    end

    context "adding all campaigns badges" do

      before do
        campaign_badge_1
        campaign_badge_2
        user.add_badge(badge_1)
        user.add_badge(badge_2)
      end

      it "not add campaign" do
        expect(user.has_complete_campaign(campaign)).to be_truthy
      end
    end
  end
end
