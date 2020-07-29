class AddCreditCardToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :credit_card, index: true
  end
end
