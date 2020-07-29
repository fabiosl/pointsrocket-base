class AddColumnDescriptionStep < ActiveRecord::Migration
  def up
    add_column :steps, :description, :text
  end

  def down
    remove_column :steps, :description
  end
end
