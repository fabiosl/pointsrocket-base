class RenameMoipIdFromInvoice < ActiveRecord::Migration
  def change
    rename_column :invoices, :moip_id, :moip_code
  end
end
