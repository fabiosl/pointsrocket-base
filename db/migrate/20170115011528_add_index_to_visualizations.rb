class AddIndexToVisualizations < ActiveRecord::Migration
  def change
    add_index :visualizations, [:user_id, :broadcast_id], unique: true
  end
end
