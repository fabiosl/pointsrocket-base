require 'rails_helper'

RSpec.describe EmployeeAdvocacyShareBrBadge do

  let(:domain) { create(:domain) }
  let(:user) { create(:user) }

  let(:employee_advocacy_share) {
    create(:employee_advocacy_share, user: user)
  }
  let(:args) { [employee_advocacy_share] }

  class DummyBrBadgeEmployeeAdvocacyShareBrBadge < EmployeeAdvocacyShareBrBadge
    def badge_slug
      "dummy"
    end
  end

  subject { DummyBrBadgeEmployeeAdvocacyShareBrBadge.new("event", domain, *args).run }

  context "with badge created" do
    let(:badge) { create(:badge, slug: "dummy") }

    context "user without badge" do

      it "adds badge to user" do
        expect {
          subject
        }.to change {
          user.has_badge?(badge)
        }.from(false).to(true)
      end

    end

    context "user with badge" do

      before do
        user.add_badge badge
      end

      it "adds badge to user" do
        expect {
          subject
        }.not_to change {
          user.has_badge?(badge)
        }
      end

    end
  end

  context "without badge created" do

      it "not raise exception" do
        expect { subject }.not_to raise_error
      end

  end


end
