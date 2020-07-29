class CreateCoinGives < ActiveRecord::Migration
  def change
    create_table :coin_gives do |t|
      t.integer :user_id, index: true
      t.text :content

      t.timestamps
    end
  end
end
