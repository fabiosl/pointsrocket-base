class AddTwitterInfoToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :twitter_app_id, :string
    add_column :domains, :twitter_app_secret, :string
  end
end
