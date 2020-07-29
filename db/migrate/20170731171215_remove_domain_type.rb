class RemoveDomainType < ActiveRecord::Migration
  def change
    remove_column :domains, :domain_type
  end
end
