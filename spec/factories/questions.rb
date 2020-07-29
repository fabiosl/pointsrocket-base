# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  step_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  archive    :string(255)
#

FactoryGirl.define do
  factory :question do
    title "MyString"
    content "MyText"
    user
    step
  end
end
