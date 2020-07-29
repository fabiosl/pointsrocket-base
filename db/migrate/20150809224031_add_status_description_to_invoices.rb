class AddStatusDescriptionToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :status_description, :string, index: true
  end
end
