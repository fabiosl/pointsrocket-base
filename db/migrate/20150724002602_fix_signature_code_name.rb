class FixSignatureCodeName < ActiveRecord::Migration
  def change
    rename_column :users, :signature_code, :moip_signature_code
  end
end
