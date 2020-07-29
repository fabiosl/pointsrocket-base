class AddEncryptedNumberToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :encrypted_number, :string
    add_column :credit_cards, :encrypted_number_salt, :string
    add_column :credit_cards, :encrypted_number_iv, :string
  end
end
