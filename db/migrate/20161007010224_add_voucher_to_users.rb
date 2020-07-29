class AddVoucherToUsers < ActiveRecord::Migration
  def change
    add_column :users, :voucher, :string, index: true
  end
end
