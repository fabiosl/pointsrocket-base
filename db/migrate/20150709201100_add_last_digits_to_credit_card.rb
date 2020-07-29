class AddLastDigitsToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :last_digits, :string
  end
end
