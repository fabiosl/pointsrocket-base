# == Schema Information
#
# Table name: categories
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  slug                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  position             :integer
#  logo                 :string(255)
#  change_to_franchisee :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :category do
    name "MyString"
slug "MyString"
  end

end
