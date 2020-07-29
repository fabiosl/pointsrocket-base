class AddCreatedInDashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_in_dash, :boolean, default: false
  end
end
