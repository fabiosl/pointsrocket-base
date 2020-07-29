require 'rails_helper'

RSpec.describe TwoHundredVisitsOnAllPosts do

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

  subject { described_class.new("", domain, *args).run }

  let(:badge) { create(:badge, slug: "two-hundred-clicks-on-all-posts") }

  context "without 200 visits" do

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

  context "with 200 visits" do

    before do
      create_list(
        :employee_advocacy_visit, 200, {
          new_visit: true,
          employee_advocacy_share: employee_advocacy_share
        })
    end

    context "user without badge" do

      it "not badge to user" do
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
