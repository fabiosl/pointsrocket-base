class AddAndroidApiKeyToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :android_api_key, :string
  end
end
