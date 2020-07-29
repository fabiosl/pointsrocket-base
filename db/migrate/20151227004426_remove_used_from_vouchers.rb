class RemoveUsedFromVouchers < ActiveRecord::Migration
  def change
    remove_column :vouchers, :used
  end
end
