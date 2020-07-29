class AddMoipSignatureCodeTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :moip_signature_code, :string
  end
end
