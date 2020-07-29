class ChangeVoucherPriceType < ActiveRecord::Migration
  def change
    change_column :vouchers, :price, :integer
  end
end
