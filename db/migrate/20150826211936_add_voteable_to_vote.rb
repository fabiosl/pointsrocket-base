class AddVoteableToVote < ActiveRecord::Migration
  def change
    add_reference :votes, :voteable, polymorphic: true, index: true
  end
end
