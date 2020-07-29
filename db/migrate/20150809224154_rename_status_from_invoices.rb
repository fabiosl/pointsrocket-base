class RenameStatusFromInvoices < ActiveRecord::Migration
  def change
    rename_column :invoices, :status, :status_code
  end
end
