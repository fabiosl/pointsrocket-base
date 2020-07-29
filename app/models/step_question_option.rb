# == Schema Information
#
# Table name: step_question_options
#
#  id               :integer          not null, primary key
#  content          :string(255)
#  correct          :boolean          default(FALSE)
#  step_question_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class StepQuestionOption < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :step_question
  has_many :question_answers, inverse_of: :step_question_option, dependent: :destroy

  scope :correct, -> { where(correct: true) }

end
