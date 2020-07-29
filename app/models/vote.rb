# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  answer_id     :integer
#  question_id   :integer
#  status        :string(255)
#  score         :integer          default(0)
#  voteable_id   :integer
#  voteable_type :string(255)
#

class Vote < ActiveRecord::Base
  belongs_to :user, inverse_of: :votes
  belongs_to :voteable, polymorphic: true

  act_as_pointable

  validates_presence_of :user
  validates_inclusion_of :status, :in => %w( upvote downvote ), :message => "status %s must be any of these -> upvote, downvote"

  scope :upvote, -> { where(status: 'upvote') }
  scope :downvote, -> { where(status: 'downvote') }

  def add_points
    self.score = 50 if self.upvote?

    if voteable
      voteable.user.add_points(self.score)
    end

  end

  def remove_points
    voteable.user.subtract_points(self.score) if self.upvote?
  end

  def upvote?
    self.status == 'upvote'
  end

  def downvote?
    self.status == 'downvote'
  end

end
