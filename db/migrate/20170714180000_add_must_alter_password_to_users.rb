class AddMustAlterPasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :must_alter_password, :boolean
  end
end
