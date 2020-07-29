class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string :code, index: true
      t.references :plan, index: true
      t.float :price
      t.datetime :valid_until
      t.boolean :active, index: true
      t.boolean :used

      t.timestamps
    end
  end
end
