# == Schema Information
#
# Table name: vouchers
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  plan_id     :integer
#  price       :integer
#  valid_until :datetime
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  used_at     :datetime
#

FactoryGirl.define do
  factory :voucher do
    code "MyString"
    plan
    price 1.5
    valid_until "2015-12-25 13:14:29"
    active false
    used_at nil
  end
end
