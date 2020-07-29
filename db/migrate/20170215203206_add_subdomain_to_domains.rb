class AddSubdomainToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :subdomain, :string
  end
end
