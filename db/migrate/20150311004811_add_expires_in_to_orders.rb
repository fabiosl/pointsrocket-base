class AddExpiresInToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expires_in, :datetime
  end
end
