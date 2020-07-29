class AddPassDomainsSelectAndLogHereDirectlyToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :pass_domains_select_and_log_here_directly, :boolean, default: false
  end
end
