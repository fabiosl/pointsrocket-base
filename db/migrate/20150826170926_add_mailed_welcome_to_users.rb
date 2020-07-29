class AddMailedWelcomeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mailed_welcome, :boolean, default: false
  end
end
