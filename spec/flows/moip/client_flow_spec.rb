require 'rails_helper'

RSpec.describe Moip::ClientFlow do
  before do
    @user = create(:user)
  end

  context "create on moip returning some id" do
    before do
      @moip_code = FFaker::Lorem.characters(10)
      allow_any_instance_of(described_class).to receive(:create_on_moip).and_return({
        success: true, code: @moip_code
      })
    end

    describe "create" do
      it "saves moip user id" do
        expect {
          described_class.new(@user).create
        }.to change {
          @user.moip_code
        }.to(@moip_code)
      end
    end
  end

  context "create_on_moip" do
    it "creates correctly on moip" do
      response = described_class.new(@user).create_on_moip
      expect(response[:success]).to be_truthy
    end
  end

  context "update credit card" do
    it "updates correctly" do
      credit_card = create(:credit_card, user: @user, number: '4532-4840-8347-7377')
      described_class.new(@user).create
      credit_card_response = described_class.new(@user).update_credit_card({credit_card: credit_card.moip_attributes})

      expect(credit_card_response[:success]).to be_truthy
    end
  end

  context "when has moip code" do
    it "not calls create" do
      user = create(:user, moip_code: '123')
      flow = described_class.new(user)
      expect(flow).not_to receive(:create_on_moip)
      flow.create
    end
  end
end
