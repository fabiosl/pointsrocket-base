# == Schema Information
#
# Table name: complete_account_question_options
#
#  id                           :integer          not null, primary key
#  complete_account_question_id :integer
#  name                         :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#

FactoryGirl.define do
  factory :complete_account_question_option do
    complete_account_question nil
name "MyString"
  end

end
