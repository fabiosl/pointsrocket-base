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

FactoryGirl.define do
  factory :address do
    street { FFaker::Address.street_name }
    number { FFaker::Address.building_number }
    complement { FFaker::Address.secondary_address }
    district { FFaker::Lorem.word }
    city { FFaker::Address.city }
    state { FFaker::Address.state }
    # country { FFaker::Address.country_code }

    # for moip - ISO-alpha3
    country { 'BRA' }
    # zipcode { FFaker::Address.zip_code }
    user
  end

end
