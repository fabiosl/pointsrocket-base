# == Schema Information
#
# Table name: invoices
#
#  id                 :integer          not null, primary key
#  subscription_id    :integer
#  amount             :integer
#  creditation_date   :datetime
#  moip_code          :integer
#  items              :string(255)
#  status_code        :integer
#  subscription_code  :integer
#  occurrence         :integer
#  customer_code      :integer
#  customer_fullname  :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  status_description :string(255)
#

FactoryGirl.define do
  factory :invoice do
    subscription nil
amount 1
creditation_date "2015-08-03 08:34:13"
moip_code 1
items "MyString"
status_code 1
subscription_code 1
occurrence 1
customer_code 1
customer_fullname "MyString"
  end

end
