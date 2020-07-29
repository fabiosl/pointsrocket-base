class RenameUpvoteForVote < ActiveRecord::Migration
  def self.up
    rename_table :upvotes, :votes
    add_column :votes, :status, :integer
  end
  def self.down
    rename_table :votes, :upvotes
    remove_column :upvotes, :status
  end
end
