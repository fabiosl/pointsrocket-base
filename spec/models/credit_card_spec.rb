# == Schema Information
#
# Table name: credit_cards
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  holder_name           :string(255)
#  expiration            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  flag                  :string(255)
#  last_digits           :string(255)
#  encrypted_number      :string(255)
#  encrypted_number_salt :string(255)
#  encrypted_number_iv   :string(255)
#

require 'rails_helper'

RSpec.describe CreditCard, type: :model do

  describe "encrypt" do
    subject {
      create(:credit_card)
    }

    it "has encrypted_number_salt" do
      expect(subject.encrypted_number_salt).not_to be_nil
    end

    it "has encrypted_number_iv" do
      expect(subject.encrypted_number_iv).not_to be_nil
    end
  end

  describe 'validation' do

    # before do
    # end

    [:user, :holder_name, :number, :expiration].each do |attribute|
      it "validates presence of #{attribute}" do
        attributes = {}
        attributes[attribute] = nil
        @credit_card = build(:credit_card, attributes)
        @credit_card.valid?
        expect(@credit_card.errors).to have_key(attribute)
      end
    end

    it "validates length of number" do
      @credit_card = build(:credit_card, number: "1231-3231-2312-3123-")
      @credit_card.valid?
      expect(@credit_card.errors).to have_key(:number)
    end

    it "validates format of expiration" do
      @credit_card = build(:credit_card, expiration: "qualquercoisa")
      @credit_card.valid?
      expect(@credit_card.errors).to have_key(:expiration)
    end

    it "validates format of expiration (valid)" do
      @credit_card = build(:credit_card, expiration: "12/1212")
      @credit_card.valid?
      expect(@credit_card.errors).not_to have_key(:expiration)
    end

  end

  describe "moip attirbutes" do
    before do
      credit_card = build(:credit_card, number: "1231-3231-2312-3123", expiration: "12/1212", holder_name: "Manoel Quirino Neto")
      @moip_attributes = credit_card.moip_attributes
    end

    it "retrieves only number" do
      expect(@moip_attributes[:number]).to eq('1231323123123123')
    end

    it "retrieves holder_name" do
      expect(@moip_attributes[:holder_name]).to eq('Manoel Quirino Neto')
    end

    it "retrieves expiration_month" do
      expect(@moip_attributes[:expiration_month]).to eq('12')
    end

    it "retrieves expiration_year" do
      expect(@moip_attributes[:expiration_year]).to eq('1212')
    end
  end

  describe "flag" do
    it "visa" do
      credit_card = create(:credit_card, number: '4123-1233-1233-3212')
      expect(credit_card.flag).to eq('visa')
    end

    it "mastercard" do
      credit_card = create(:credit_card, number: '5123-1233-1233-3212')
      expect(credit_card.flag).to eq('mastercard')
    end

    it "dinners" do
      credit_card = create(:credit_card, number: '3013-1233-1233-3212')
      expect(credit_card.flag).to eq('dinners')
    end

    # conflito com hipercard segundo o link
    # http://pt.stackoverflow.com/questions/3715/express%C3%A3o-regular-para-detectar-a-bandeira-do-cart%C3%A3o-de-cr%C3%A9dito
    # it "dinners 2" do
    #   credit_card = create(:credit_card, number: '3813-1233-1233-3212')
    #   expect(credit_card.flag).to eq('dinners')
    # end

    it "elo" do
      credit_card = create(:credit_card, number: '6363-6833-1233-3212')
      expect(credit_card.flag).to eq('elo')
    end
  end

  describe "last digits" do
    it "sets last digits" do
      credit_card = create(:credit_card, number: '4123-1233-1233-3212')
      expect(credit_card.last_digits).to eq('3212')
    end
  end
end
