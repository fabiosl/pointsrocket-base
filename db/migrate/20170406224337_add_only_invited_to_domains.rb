class AddOnlyInvitedToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :only_invited, :boolean, default: false
  end
end
