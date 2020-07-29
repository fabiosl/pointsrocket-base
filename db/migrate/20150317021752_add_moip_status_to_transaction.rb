class AddMoipStatusToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :moip_status, :string
  end
end
