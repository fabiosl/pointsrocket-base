require 'rails_helper'

RSpec.describe SuspendSubscriptionNotRenewFlow do
  subject {
    described_class.new(subscription)
  }

  let!(:subscription) {
    create(:subscription, {
      status: status,
      moip_code: moip_code
    })
  }

  let(:status) { 'ACTIVE' }
  let(:moip_code) { '1451933853' }

  context "suspend!" do
    it "sets status to suspended" do
      expect {
        subject.suspend!
      }.to change(
        subscription, :status
      ).to 'SUSPENDED'
    end

    it "sets suspended_in to now" do
      # freeze Time.now
      allow(Time).to receive(:now).and_return(Time.now)

      expect {
        subject.suspend!
      }.to change(
        subscription, :suspended_in
      ).to Time.now
    end
  end

  context "run_for_all_subscriptions" do
    it "sets status to suspended" do
      expect {
        described_class.run_for_all_subscriptions
      }.not_to change(
        subscription, :status
      )
    end

    it "sets suspended_in to now" do
      # freeze Time.now
      allow(Time).to receive(:now).and_return(Time.now)

      expect {
        described_class.run_for_all_subscriptions
      }.not_to change(
        subscription, :suspended_in
      )
    end

    context "with read_to_suspend true" do
      before do
        allow_any_instance_of(Subscription).to receive('ready_to_suspend?').and_return(true)
      end

      it "sets status to suspended" do
        described_class.run_for_all_subscriptions
        subscription.reload
        expect(subscription.status).to eql('SUSPENDED')
      end

      it "sets suspended_in to now" do
        # freeze Time.now
        allow(Time).to receive(:now).and_return(Time.now)
        described_class.run_for_all_subscriptions
        subscription.reload
        expect(subscription.suspended_in).to eql(Time.now)
      end
    end
  end
end
