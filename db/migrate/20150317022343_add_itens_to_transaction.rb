class AddItensToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :moip_invoice_id, :integer
    add_column :transactions, :moip_invoice_code, :integer
    add_column :transactions, :moip_invoice_description, :string
    add_column :transactions, :next_invoice, :datetime
  end
end
