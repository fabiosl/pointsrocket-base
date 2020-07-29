class AddCanManageAllDomainsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_manage_all_domains, :boolean, default: false
  end
end
