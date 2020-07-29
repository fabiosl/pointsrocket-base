# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  slug        :string(255)
#  hours       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  age_group   :string(255)
#  video_url   :string(255)
#  active      :boolean          default(TRUE)
#

FactoryGirl.define do
  factory :trail do
    name "MyString"
description "MyText"
slug "MyString"
hours "MyString"
  end

end
