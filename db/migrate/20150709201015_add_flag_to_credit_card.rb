class AddFlagToCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :flag, :string, index: true
  end
end
