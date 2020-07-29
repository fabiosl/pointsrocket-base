class VoteFlow

  def initialize user
    @user = user
  end

  def up voteable
    self.flow voteable, 'upvote', ENV['VOTE_VALUE'].to_i
  end

  def down voteable
    self.flow voteable, 'downvote', -ENV['VOTE_VALUE'].to_i
  end

  def destroy_vote vote, voteable
    voteable.user.points.where(
      pointable: vote
    ).destroy_all

    vote.destroy
  end

  def create_vote voteable, status, points
    vote_params = get_vote_params(voteable)

    vote = @user.votes.create!(vote_params.merge({
      status: status
    }))

    voteable.user.points.create(
      value: points,
      pointable: vote
    )
  end

  def flow voteable, status, points
    vote_params = get_vote_params(voteable)

    vote = @user.votes.where(vote_params).first

    if vote
      if vote.status != status
        self.destroy_vote vote, voteable
        self.create_vote voteable, status, points
      else
        self.destroy_vote vote, voteable
      end
    else
      self.create_vote(voteable, status, points)
    end

  end

  def get_vote_params voteable
    {
      voteable: voteable
    }
  end

end
