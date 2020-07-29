class AddFieldsToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :age_group, :string
    add_column :trails, :video_url, :string
  end
end
