# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :text
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  archive     :string(255)
#

class Answer < ActiveRecord::Base
  include AdminNotifiable
  include MentionableContent

  belongs_to :user
  belongs_to :question

  has_many :votes, as: :voteable, dependent: :destroy

  validates_presence_of :content, :user, :question

  act_as_pointable
  act_as_searchable

  act_as_timelineable only_relation: true, update_relations: [:question]

  mount_uploader :archive, FileUploader

  def search_content
    "#{self.content}"
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
