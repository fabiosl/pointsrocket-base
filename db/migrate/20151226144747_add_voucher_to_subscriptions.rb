class AddVoucherToSubscriptions < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :voucher, index: true
  end
end
