class AddFbAppToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :facebook_app_id, :string
    add_column :domains, :facebook_app_secret, :string
  end
end
