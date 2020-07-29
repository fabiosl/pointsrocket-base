# == Schema Information
#
# Table name: complete_account_question_option_users
#
#  id                                  :integer          not null, primary key
#  complete_account_question_option_id :integer
#  user_id                             :integer
#  created_at                          :datetime
#  updated_at                          :datetime
#

FactoryGirl.define do
  factory :complete_account_question_option_user do
    complete_account_question_option nil
user nil
  end

end
