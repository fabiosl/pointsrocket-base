class AddStatusToVisualizations < ActiveRecord::Migration
  def change
    add_column :visualizations, :status, :string
  end
end
