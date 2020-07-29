# == Schema Information
#
# Table name: step_questions
#
#  id         :integer          not null, primary key
#  question   :string(255)
#  hint       :string(255)
#  score      :integer
#  step_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class StepQuestion < ActiveRecord::Base
  validates :question, presence: true
  # validates :hint, presence: true
  # validates :score, presence: true

  has_many :step_question_options, dependent: :destroy
  has_many :question_answers, inverse_of: :step_question, dependent: :destroy
  belongs_to :step, inverse_of: :step_questions

  scope :by_position, -> { order('position asc') }

  accepts_nested_attributes_for :step_question_options, :allow_destroy => true
  act_as_pointable

  def score
    super || ENV['DEFAULT_STEP_QUESTION_POINTS'].to_i
  end

  def answered_correctly_by_user?(user)
    step_question_option_correct = self.step_question_options.correct.first

    return false if not step_question_option_correct

    QuestionAnswer.where(user: user, step_question: self, step_question_option: step_question_option_correct).any?
  end

  def answered_wrongly_by_user?(user)
    step_question_option_correct = self.step_question_options.correct.first

    return false if not step_question_option_correct

    QuestionAnswer.where(user: user, step_question: self).where.not(step_question_option: step_question_option_correct).any?
  end
end
