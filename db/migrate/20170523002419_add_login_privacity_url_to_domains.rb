class AddLoginPrivacityUrlToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :login_terms_url, :string
  end
end
