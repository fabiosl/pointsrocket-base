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

class CompleteAccountQuestionOption < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :complete_account_question, inverse_of: :complete_account_question_options

  has_many :complete_account_question_option_users, inverse_of: :complete_account_question_option
  has_many :users, through: :complete_account_question_option_users
end
