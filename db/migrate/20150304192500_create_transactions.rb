class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :card_hash
      t.references :order, index: true

      t.timestamps
    end
  end
end
