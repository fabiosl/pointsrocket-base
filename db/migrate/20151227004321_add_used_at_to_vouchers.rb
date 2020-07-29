class AddUsedAtToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :used_at, :datetime
  end
end
