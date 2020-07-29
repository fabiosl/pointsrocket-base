# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  pointable_id   :integer
#  pointable_type :string(255)
#  value          :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'

RSpec.describe Point, type: :model do
  describe "#to_i" do
    before do
      create(:point, value: 10)
      create(:point, value: -5)
      create(:point, value: 20)
    end

    it 'returns sum' do
      expect(described_class.to_i).to eql(25)
    end
  end

  describe "datetime queries" do
    before do
      @point_now = create(:point)
      @point_yesterday = create(:point, created_at: 1.day.ago)
      @point_last_week = create(:point, created_at: 1.week.ago)
      @point_month_week = create(:point, created_at: 1.month.ago)
    end

    describe "#last_24_hours" do
      it 'returns correct posts' do
        expect(described_class.last_24_hours).to match_array([@point_now])
      end
    end

    describe "#last_7_days" do
      it 'returns correct posts' do
        expect(described_class.last_7_days).to match_array([@point_now, @point_yesterday])
      end
    end

    describe "#last_month" do
      it 'returns correct posts' do
        expect(described_class.last_month).to match_array([@point_now, @point_yesterday, @point_last_week])
      end
    end
  end

  context "on creating" do
    let(:user) {
      create(:user)
    }

    it "saves sum_points in user" do
      point = create(:point, value: 10, user: user)
      user.reload
      expect(user.sum_points).to eql(10)
    end
  end

  context "on deleting" do
    let(:user) {
      create(:user)
    }

    before do
      point = create(:point, value: 20, user: user)
      @point_deleted = create(:point, value: 10, user: user)
    end

    it "saves sum_points in user" do
      @point_deleted.destroy
      user.reload
      expect(user.sum_points).to eql(20)
    end
  end
end
