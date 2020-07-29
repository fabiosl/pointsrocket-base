class AddLastAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_access, :datetime
  end
end
