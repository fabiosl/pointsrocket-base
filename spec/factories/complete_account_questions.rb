# == Schema Information
#
# Table name: complete_account_questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :complete_account_question do
    title "MyString"
  end

end
