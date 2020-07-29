require 'rails_helper'

RSpec.describe CancelFlow do
  context "not suspended" do
    context "trial" do
      before do
        @subscription = create(:subscription, status: 'TRIAL', moip_code: 123, trial_end_time: 7.days.from_now)
      end

      it "suspend moip signagure" do
        expect_any_instance_of(Moip::SubscriptionFlow).to receive(:suspend).once().and_return({
          success: true
        })

        described_class.new(@subscription).cancel
      end
    end

    context "active on moip but trial" do
      before do
        @subscription = create(:subscription, status: 'ACTIVE', trial_end_time: 7.days.from_now)
      end

      it "suspend moip signagure" do
        expect_any_instance_of(Moip::SubscriptionFlow).to receive(:suspend).once().and_return({
          success: true
        })

        described_class.new(@subscription).cancel
      end
    end

    context "active" do
      before do
        @subscription = create(:subscription, status: 'ACTIVE', moip_code: 123)
      end

      it "mark for no renew" do
        expect {
          described_class.new(@subscription).cancel
        }.to change {
          @subscription.not_renew
        }.to(true)
      end
    end
  end

  # context "check_signature_status" do

  #   context "active" do
  #     subject do
  #       @user = create(:user, signature_status: 'active')
  #       described_class.new(@user).check_signature_status
  #     end

  #     it "renew" do
  #       expect(subject[:renew]).to be_truthy
  #     end

  #     it "no suspended" do
  #       expect(subject[:suspended]).to be_falsey
  #     end
  #   end

  #   context "no_renew" do
  #     subject do
  #       @user = create(:user, signature_status: 'no_renew', created_at: 7.days.ago)
  #       described_class.new(@user).check_signature_status
  #     end

  #     it "no renew" do
  #       expect(subject[:renew]).to be_falsey
  #     end

  #     it "no suspended" do
  #       expect(subject[:suspended]).to be_falsey
  #     end
  #   end

  #   context "suspended" do
  #     context "trial" do
  #       subject do
  #         @user = create(:user, signature_status: 'suspended', created_at: Time.now)
  #         described_class.new(@user).check_signature_status
  #       end

  #       it "no renew" do
  #         expect(subject[:renew]).to be_falsey
  #       end

  #       it "suspended" do
  #         expect(subject[:suspended]).to be_truthy
  #       end

  #       it "trial" do
  #         expect(subject[:trial]).to be_truthy
  #       end
  #     end

  #     context "passed trial time" do
  #       subject do
  #         @user = create(:user, signature_status: 'suspended', created_at: 8.days.ago)
  #         described_class.new(@user).check_signature_status
  #       end

  #       it "no renew" do
  #         expect(subject[:renew]).to be_falsey
  #       end

  #       it "suspended" do
  #         expect(subject[:suspended]).to be_truthy
  #       end

  #       it "no trial" do
  #         expect(subject[:trial]).to be_falsey
  #       end
  #     end
  #   end

  # end
end
