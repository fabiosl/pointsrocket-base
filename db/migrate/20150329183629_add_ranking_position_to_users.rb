class AddRankingPositionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ranking_position, :integer
  end
end
