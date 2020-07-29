require 'rails_helper'
require 'shared_contexts'

RSpec.describe "ChangeCreditCard", type: :feature do
  include_context "api request authentication helper methods"
  include_context "api request global before and after hooks"

  # cc holder name
  let(:credit_card_holder_name) { FFaker::Name.name }

  # cc number
  let(:credit_card_number) { "4539-3920-9160-9449" }

  # cc expires at
  let(:credit_card_expiration) { 1.year.from_now.strftime("%m/%y") }

  let(:user) {
    user = create(:subscription, status: 'TRIAL').user
    create(:credit_card, user: user)
    user.has_submited_payment_form = true
    user.moip_code = '2016-01-04-23-41-39-0200314'
    user.save
    user
  }

  def submit_credit_card
    sign_in user
    visit change_credit_card_path
    fill_in "credit_card_holder_name", with: credit_card_holder_name
    fill_in "credit_card_number", with: credit_card_number
    fill_in "credit_card_expiration", with: credit_card_expiration
    click_button "Atualizar cartão de crédito"
  end

  describe "change credit card" do
    context "with valid credit card" do
      it "show success message" do
        submit_credit_card
        expect(page).to have_content("Cartão de crédito alterado com sucesso")
      end
    end

    context "with invalid credit card" do
      let(:credit_card_holder_name) { '' }

      it "show failure message" do
        submit_credit_card
        expect(page).to have_content("Houve um erro ao tentar atualizar cartão de crédito")
      end
    end
  end
end
