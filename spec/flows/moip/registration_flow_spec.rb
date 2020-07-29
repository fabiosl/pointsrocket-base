require 'rails_helper'

RSpec.describe Moip::RegistrationFlow do

  let(:user) { create(:user) }

  before do
    create(:credit_card, user: user)
    create(:address, user: user)
    deliver_double = double()
    allow(deliver_double).to receive(:deliver).and_return(true)
    # allow_any_instance_of(TransactionalMailer).to receive(:welcome).and_return(deliver_double)
  end

  # liberar em sandbox do moip
  # context "when not sended welcome mail" do
  #   # it "create subscription" do
  #   #   described_class.new(user).register!
  #   #   expect(Subscription.count).to be(1)
  #   # end

  #   # it "create invoice" do
  #   #   described_class.new(user).register!
  #   #   expect(Invoice.count).to be(1)
  #   # end

  #   it "sends welcome email" do
  #     expect_any_instance_of(TransactionalMailer).to receive(:welcome)
  #     described_class.new(user).register!
  #   end

  # #   it "saves mailed_welcome in user" do
  # #     described_class.new(user).register!
  # #     expect_any_instance_of(user.mailed_welcome).to be_true
  # #   end
  # end

  context "when submit invalid moip attributes" do
    let(:user) {
      create(:user)
    }

    let(:credit_card_response) {
      {:success=>false, :message=>"Erro na requisição", :errors=>[{"description"=>"Dados inválidos", "code"=>"MC5"}]}
    }

    let(:credit_card) {
      create(
        :credit_card, user: user,
        number: '1233-1233-1333-9947',
        holder_name: 'Manoel Q Neto',
        expiration: '10/16',
      )
    }

    before do
      expect_any_instance_of(Moip::ClientFlow).to receive(:create).and_return(true)
      expect_any_instance_of(Moip::ClientFlow).to receive(:update_credit_card).and_return(
        credit_card_response
      )
    end

    it "returns errors" do
      response = described_class.new(user).register!
      expect(response).to eql(credit_card_response)
    end
  end
end
