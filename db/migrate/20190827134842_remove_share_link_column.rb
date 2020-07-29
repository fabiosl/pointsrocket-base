class RemoveShareLinkColumn < ActiveRecord::Migration
  def change
    remove_column :domains, :share_link_in_advocacy
  end
end
