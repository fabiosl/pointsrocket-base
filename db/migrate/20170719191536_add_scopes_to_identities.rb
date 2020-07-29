class AddScopesToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :scopes, :text
  end
end
