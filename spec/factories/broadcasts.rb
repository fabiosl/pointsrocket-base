# == Schema Information
#
# Table name: broadcasts
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  url           :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  schedule_time :datetime
#  description   :text
#  badge_id      :integer
#  points        :integer
#  slug          :string(255)
#

FactoryGirl.define do
  factory :broadcast do
    title "MyString"
url "MyString"
  end

end
