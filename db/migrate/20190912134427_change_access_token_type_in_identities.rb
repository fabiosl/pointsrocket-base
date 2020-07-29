class ChangeAccessTokenTypeInIdentities < ActiveRecord::Migration
  def change
    change_column :identities, :access_token, :text
  end
end
