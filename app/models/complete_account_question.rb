# == Schema Information
#
# Table name: complete_account_questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CompleteAccountQuestion < ActiveRecord::Base
  validates_presence_of :title
  has_many :complete_account_question_options,
    inverse_of: :complete_account_question, dependent: :destroy

  accepts_nested_attributes_for :complete_account_question_options, :allow_destroy => true

end
