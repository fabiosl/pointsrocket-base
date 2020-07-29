class AddJsonToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :json, :text
  end
end
