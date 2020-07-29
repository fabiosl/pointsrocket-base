class CreateCoinUsers < ActiveRecord::Migration
  def change
    create_table :coin_users do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :points, default: 0

      t.timestamps
    end
  end
end
