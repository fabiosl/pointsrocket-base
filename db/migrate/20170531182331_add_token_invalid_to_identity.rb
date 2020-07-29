class AddTokenInvalidToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :token_invalid, :boolean, default: false
  end
end
