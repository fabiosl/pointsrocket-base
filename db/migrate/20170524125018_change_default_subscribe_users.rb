class ChangeDefaultSubscribeUsers < ActiveRecord::Migration
  def change
    change_column :users, :subscribe, :boolean, :default => true
  end
end
