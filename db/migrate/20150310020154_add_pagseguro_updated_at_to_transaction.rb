class AddPagseguroUpdatedAtToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :pagseguro_updated_at, :datetime
  end
end
