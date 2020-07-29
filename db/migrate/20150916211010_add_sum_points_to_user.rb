class AddSumPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :sum_points, :integer, default: 0
  end
end
