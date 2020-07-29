require 'rails_helper'

RSpec.describe VisitsOnPost do

  let(:domain) { create(:domain) }
  let(:user) { create(:user) }

  let(:employee_advocacy_share) {
    create(:employee_advocacy_share, user: user)
  }

  let(:employee_advocacy_visit) {
    create(:employee_advocacy_visit, {
      employee_advocacy_share: employee_advocacy_share,
      new_visit: false
    })
  }

  let(:args) { [employee_advocacy_visit] }

  class DummyVisitsOnPost < VisitsOnPost
    def min_visits_count
      10
    end

    def badge_slug
      "dummy"
    end
  end

  subject { DummyVisitsOnPost.new("", domain, *args).run }

  let(:badge) { create(:badge, slug: "dummy") }

  context "without ten visits" do

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

  context "with nine visits" do

    before do
      create_list(
        :employee_advocacy_visit, 9, {
          new_visit: true,
          employee_advocacy_share: employee_advocacy_share
        })
    end

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

  context "with ten visits" do

    before do
      create_list(
        :employee_advocacy_visit, 10, {
          new_visit: true,
          employee_advocacy_share: employee_advocacy_share
        })
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

  context "without badge created" do

    it "not raise exception" do
      expect { subject }.not_to raise_error
    end

  end


end
