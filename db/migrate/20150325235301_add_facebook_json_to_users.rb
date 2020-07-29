class AddFacebookJsonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_json, :text
  end
end
