class AddNeedsEditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :needs_edit, :boolean, default: true
  end
end
