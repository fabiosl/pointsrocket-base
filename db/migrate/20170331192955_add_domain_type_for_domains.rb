class AddDomainTypeForDomains < ActiveRecord::Migration
  def change
    add_column :domains, :domain_type, :text, default: 'community'
  end
end
