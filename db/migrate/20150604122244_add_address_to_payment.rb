class AddAddressToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :address, index: true
  end
end
