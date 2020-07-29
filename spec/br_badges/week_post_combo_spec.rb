require 'rails_helper'

RSpec.describe TwoWeekPostCombo do

  let(:domain) { create(:domain) }
  let(:user) { create(:user) }

  let(:employee_advocacy_share) {
    create(:employee_advocacy_share, user: user)
  }

  let(:args) { [employee_advocacy_share] }

  class DummyTwoWeekPostCombo < TwoWeekPostCombo
    def weeks_count
      2
    end

    def badge_slug
      "dummy"
    end
  end

  subject { DummyTwoWeekPostCombo.new("", domain, *args).run }

  let(:badge) { create(:badge, slug: "dummy") }

  context "without post in weeks" do

    context "user without badge" do

      it "not adds badge to user" do
        expect {
          subject
        }.not_to change {
          user.has_badge?(badge)
        }
      end

    end
  end

  context "with post in weeks" do

    before do
      create(:employee_advocacy_share, user: user, created_at: 1.week.ago)
      create(:employee_advocacy_share, user: user, created_at: Time.now)
    end

    context "user without badge" do

      it "adds badge to user" do
        expect {
          subject
        }.to change {
          user.has_badge?(badge)
        }.from(false).to(true)
      end

    end
  end

end
