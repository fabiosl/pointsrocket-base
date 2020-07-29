class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :lang, :string
    add_column :users, :timezone, :string
    add_column :users, :country, :string
    add_column :users, :see_sensitive_media, :boolean, default: false
    add_column :users, :mark_sensitive_media, :boolean, default: false
  end
end
