# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  street     :string(255)
#  number     :integer
#  complement :string(255)
#  district   :string(255)
#  city       :string(255)
#  state      :string(255)
#  country    :string(255)
#  zipcode    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "validation" do
    # [:street, :number, :district, :state, :country, :zipcode, :city].each do |attribute|
    [:country].each do |attribute|
      it "validates presence of #{attribute}" do
        attributes = {}
        attributes[attribute] = nil
        @address = build(:address, attributes)
        @address.valid?
        expect(@address.errors).to have_key(attribute)
      end
    end
  end

  describe "moip attirbutes" do
    attributes = {
      street: "Rua Mocinha Caldas",
      number: 123,
      district: "Nova Brasília",
      city: "Sapé",
      state: "Paraíba",
      country: "BRA",
      complement: "apt 205",
      zipcode: "58340000"
    }

    before do
      address = create(:address, attributes)
      @moip_attributes = address.moip_attributes
    end

    attributes.each do |k, v|
      it "retrieves #{k}" do
        expect(@moip_attributes[k]).to eq(v)
      end
    end
  end

  describe "no zipcode" do
    subject do
      address = create(:address)
    end

    it "is zipcode from sape" do
      expect(subject.zipcode).to eq('58340000')
    end
  end


end
