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

class CompleteAccountQuestionOptionUser < ActiveRecord::Base
  belongs_to :complete_account_question_option, inverse_of: :complete_account_question_option_users
  belongs_to :user, inverse_of: :complete_account_question_option_users
end
