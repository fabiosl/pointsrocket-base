class AddSocialNetworkPermitedsToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :social_network_permiteds, :text
  end
end
