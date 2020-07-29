# == Schema Information
#
# Table name: challenges
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  date_start     :datetime
#  date_end       :datetime
#  points         :integer
#  description    :text
#  image          :string(255)
#  slug           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  badge_id       :integer
#  terms          :text
#  privacy        :string(255)      default("all")
#  recommendation :text
#

FactoryGirl.define do
  factory :challenge do
    title "MyString"
date_start "2017-01-09 17:20:45"
date_end "2017-01-09 17:20:45"
points 1
description "MyText"
image "MyString"
slug "MyString"
  end

end
