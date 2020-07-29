# == Schema Information
#
# Table name: steps
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  url         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#  description :text
#  topic_id    :integer
#  position    :integer
#  step_type   :string(255)
#  free        :boolean          default(FALSE)
#  score       :integer          default(0)
#

class Step < ActiveRecord::Base
  validates :name, presence: true

  has_many :step_questions, inverse_of: :step, dependent: :destroy
  has_many :user_steps, inverse_of: :step, dependent: :destroy
  has_many :archives, as: :archiveable, dependent: :destroy
  has_many :questions, inverse_of: :step, dependent: :destroy

  belongs_to :chapter, inverse_of: :steps

  accepts_nested_attributes_for :step_questions, :allow_destroy => true
  accepts_nested_attributes_for :archives, :allow_destroy => true

  scope :videos, -> { where(step_type: 'Vídeo') }
  scope :quizes, -> { where(step_type: 'Quiz') }
  scope :by_position, -> { order('position asc') }
  act_as_pointable

  act_as_searchable

  def search_content
    "#{self.name} #{self.description}"
  end

  def ordered_step_questions
    step_questions.by_position
  end

  def self.points
    # videos_points = self.videos.count * ENV['DEFAULT_STEP_POINTS'].to_i
    videos_points = self.videos.sum('score')

    quizes_without_points = self.quizes.joins(
      'LEFT JOIN step_questions ON step_questions.step_id = steps.id').where(
      step_questions: {score: nil}).count * ENV['DEFAULT_STEP_QUESTION_POINTS'].to_i

    quizes_with_points = self.quizes.joins(:step_questions).uniq.sum("step_questions.score")
    # quizes_with_points = Step.quizes.joins(:step_questions).inject(0) do |sum, step|
    #   sum + step.step_questions.to_a.sum(&:score)
    # end

    videos_points + quizes_without_points + quizes_with_points
  end

  def answered_correctly_by_user?(user)
    self.step_questions.each do |step_question|
      if not QuestionAnswer.where(user: user, step_question: step_question, step_question_option: step_question.step_question_options.correct.first).any?
        return false
      end
    end

    return true
  end

  def embed_url
    Youtube::UrlHelpers.embed_url(url)
  end

  def video_id
    Youtube::DataHelpers.video_id(url)
  end
end
