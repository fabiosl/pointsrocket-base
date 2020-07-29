class AddInstallmentsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :installments, :integer
  end
end
