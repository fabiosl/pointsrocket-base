require 'rails_helper'
require 'shared_contexts'

RSpec.describe "Vouchers", type: :feature do
  include_context "api request authentication helper methods"
  include_context "api request global before and after hooks"

  let!(:voucher) { create(:voucher,
      code: code,
      plan: plan,
      price: price,
      valid_until: valid_until,
      active: active,
      used_at: used_at
    )
  }

  # code of token
  let!(:code) { FFaker::Code.ean }

  # plan of token
  let!(:plan) { create(:plan, active: true) }

  # price of token
  let!(:price) { FFaker::Number.decimal(2) }

  # valid until
  let!(:valid_until) { 2.days.from_now }

  # active
  let!(:active) { true }

  # used_at
  let!(:used_at) { nil }

  # cc holder name
  let(:credit_card_holder_name) { FFaker::Name.name }

  # cc number
  let(:credit_card_number) { FFaker::Business.credit_card_number }

  # cc expires at
  let(:credit_card_expiration) { 1.year.from_now.strftime("%m/%y") }

  let(:user) { create(:user) }

  def activate_voucher code
    sign_in user
    visit payment_complete_registration_index_path
    fill_in "voucher", with: code
    click_button "Quero meu desconto!"
  end

  describe "apply voucher" do
    context "with valid voucher" do
      it "apply voucher when requesting voucher" do
        activate_voucher voucher.code
        expect(page).to have_content("Voucher ativo com sucesso!")
        expect(page).to have_content(voucher.decorate.formatted_description)
        expect(page).not_to have_selector("#user_plan_id")
      end
    end

    context "with invalid voucher" do
      let!(:used_at) { Time.now }

      it "show voucher not found" do
        activate_voucher voucher.code
        expect(page).to have_content("Voucher não encontrado!")
        expect(page).to have_selector("#user_plan_id")
      end
    end
  end

  context "clear voucher" do
    it "clears voucher" do
      activate_voucher voucher.code
      click_link "Não quero este voucher"
      expect(page).to have_content("Voucher removido com sucesso")
      expect(page).not_to have_content(voucher.decorate.formatted_description)
      expect(page).to have_selector("#user_plan_id")
    end
  end

  # context "buy with voucher" do
  #   it "sets the correct price" do
  #     activate_voucher voucher.code
  #     fill_in "user_credit_cards_attributes_0_holder_name", with: credit_card_holder_name
  #     fill_in "user_credit_cards_attributes_0_number", with: credit_card_number
  #     fill_in "user_credit_cards_attributes_0_expiration", with: credit_card_expiration
  #     click_button "Assinar agora!"
  #     save_and_open_page
  #   end
  # end
end
