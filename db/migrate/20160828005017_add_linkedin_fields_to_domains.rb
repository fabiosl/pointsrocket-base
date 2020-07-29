class AddLinkedinFieldsToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :linkedin_app_id, :string
    add_column :domains, :linkedin_app_secret, :string
  end
end
