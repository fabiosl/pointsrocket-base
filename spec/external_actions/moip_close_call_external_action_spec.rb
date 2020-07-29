require 'rails_helper'

RSpec.describe MoipCloseCallExternalAction do
  let!(:domain) { create(:domain, tag_list: 'teste') }
  let!(:user) { create(:user, email: 'mail@mail.com') }
  let!(:badge) { create(:badge, slug: 'moip-close-call', badge_points: 10, tag_list: domain.tag_list) }

  let(:external_action) { create(:external_action,
    text: "type=moip_close_call%S%email=mail@mail.com",
    domain: domain)
  }

  context "run" do
    subject { described_class.new(external_action).run }

    context "when pass all valid fields" do
      it "add badge to user" do
        subject
        user.reload
        expect(user.has_badge?(badge)).to be_truthy
      end
    end
  end

end
