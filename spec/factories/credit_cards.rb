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

FactoryGirl.define do
  factory :credit_card do
    user
    holder_name { FFaker::Name.name }
    number { FFaker::Business.credit_card_number }
    expiration { 2.years.from_now.strftime("%m/%y") }
  end

end
