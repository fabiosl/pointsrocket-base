# == Schema Information
#
# Table name: question_answers
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  step_question_id        :integer
#  step_question_option_id :integer
#  created_at              :datetime
#  updated_at              :datetime
#  score_added             :boolean          default(FALSE)
#

class QuestionAnswer < ActiveRecord::Base
  belongs_to :user, inverse_of: :question_answers
  belongs_to :step_question, inverse_of: :question_answers
  belongs_to :step_question_option, inverse_of: :question_answers

  validates_presence_of :step_question_option_id
  # act_as_timelineable type: :user

end
