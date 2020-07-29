class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.references :user, index: true
      t.string :holder_name
      t.string :number
      t.string :expiration

      t.timestamps
    end
  end
end
