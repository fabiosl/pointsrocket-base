class ChangeFinantialToPoints < ActiveRecord::Migration
  def change
    rename_column :domains, :has_finantial, :is_points
  end
end
