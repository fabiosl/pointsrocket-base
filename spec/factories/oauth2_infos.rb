# == Schema Information
#
# Table name: oauth2_infos
#
#  id            :integer          not null, primary key
#  provider      :string(255)
#  uid           :string(255)
#  access_token  :string(255)
#  refresh_token :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

FactoryGirl.define do
  factory :oauth2_info do
    provider "MyString"
uid "MyString"
access_token "MyString"
refresh_token "MyString"
  end

end
