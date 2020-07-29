class AddSignatureFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :signature_code, :string
    add_column :users, :signature_status, :string, index: true
  end
end
