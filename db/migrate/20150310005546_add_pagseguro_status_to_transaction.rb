class AddPagseguroStatusToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :pagseguro_status, :integer
  end
end
