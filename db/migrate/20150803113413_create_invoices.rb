class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :subscription, index: true
      t.integer :amount
      t.datetime :creditation_date
      t.integer :moip_id
      t.string :items
      t.integer :status
      t.integer :subscription_code
      t.integer :ocurrence
      t.integer :customer_code
      t.string :customer_fullname

      t.timestamps
    end
  end
end
