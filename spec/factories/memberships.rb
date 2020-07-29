# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  role       :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :membership do
    user nil
domain nil
status "MyString"
  end

end
