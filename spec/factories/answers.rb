# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :text
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  archive     :string(255)
#

FactoryGirl.define do
  factory :answer do
    content "MyText"
user
question
  end

end
