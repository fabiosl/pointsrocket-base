# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  step_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  archive    :string(255)
#

class Question < ActiveRecord::Base
  include AdminNotifiable
  include MentionableContent

  belongs_to :user
  belongs_to :step, inverse_of: :questions

  has_many :answers, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  act_as_pointable
  acts_as_taggable
  act_as_searchable
  act_as_timelineable type: :user

  mount_uploader :archive, FileUploader


  def search_content
    "#{self.title} #{self.content}"
  end

  validates_presence_of :title, :content, :user

  default_scope { order('created_at DESC') }

  scope :with_answers, -> {
    where('questions.id IN (SELECT DISTINCT(question_id) FROM ANSWERS)')
  }

  scope :without_answers, -> {
    where('questions.id NOT IN (SELECT DISTINCT(question_id) FROM ANSWERS)')
  }

  def last_answers
    self.answers.last(3)
  end

  def upvotes(user = nil)
    user.nil? ? self.votes.upvote : self.votes.upvote.where(user: user)
  end

  def downvotes(user = nil)
    user.nil? ? self.votes.downvote : self.votes.downvote.where(user: user)
  end

  def total_upvotes
    self.upvotes.count
  end

  def total_downvotes
    self.downvotes.count
  end

  def total_votes
    self.total_upvotes - self.total_downvotes
  end
end
