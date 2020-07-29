class AddLoginProvidersToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :login_providers, :string
  end
end
