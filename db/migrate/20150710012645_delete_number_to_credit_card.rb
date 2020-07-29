class DeleteNumberToCreditCard < ActiveRecord::Migration
  def change
    remove_column :credit_cards, :number
  end
end
