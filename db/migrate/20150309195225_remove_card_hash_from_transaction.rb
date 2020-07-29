class RemoveCardHashFromTransaction < ActiveRecord::Migration
  def change
    remove_column :transactions, :card_hash
  end
end
