# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  pointable_id   :integer
#  pointable_type :string(255)
#  value          :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

FactoryGirl.define do
  factory :point do
    user
    pointable nil
    value 1
  end

end
