class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.float :price
      t.references :plan, index: true

      t.timestamps
    end
  end
end
