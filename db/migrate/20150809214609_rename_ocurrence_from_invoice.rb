class RenameOcurrenceFromInvoice < ActiveRecord::Migration
  def change
    rename_column :invoices, :ocurrence, :occurrence
  end
end
