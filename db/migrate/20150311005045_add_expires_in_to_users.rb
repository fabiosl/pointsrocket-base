class AddExpiresInToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expires_in, :datetime
  end
end
