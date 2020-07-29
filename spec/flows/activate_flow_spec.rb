require 'rails_helper'

RSpec.describe ActivateFlow do

  context "suspended" do
    before do
      @subscription = create(:subscription, status: 'SUSPENDED', moip_code: 123)
    end

    it "activate moip signagure" do
      expect_any_instance_of(Moip::SubscriptionFlow).to receive(:activate).once().and_return({
        success: true
      })

      described_class.new(@subscription).activate
    end
  end

  context "not_renew" do
    before do
      @subscription = create(:subscription, status: 'ACTIVE', moip_code: 123, not_renew: true)
    end

    it "mark for renew" do
      expect {
        described_class.new(@subscription).activate
      }.to change {
        @subscription.not_renew
      }.to(false)
    end
  end
end
