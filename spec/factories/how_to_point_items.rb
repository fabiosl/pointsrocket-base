# == Schema Information
#
# Table name: how_to_point_items
#
#  id          :integer          not null, primary key
#  points      :integer
#  description :string(255)
#  section     :string(255)
#  domain_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :how_to_point_item do
    points 1
description "MyString"
section "MyString"
domain nil
  end

end
