class AddScoreToVote < ActiveRecord::Migration
  def change
    add_column :votes, :score, :integer, default: 0
  end
end
