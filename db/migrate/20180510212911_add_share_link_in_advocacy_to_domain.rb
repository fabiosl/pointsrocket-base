class AddShareLinkInAdvocacyToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :share_link_in_advocacy, :boolean, default: true
  end
end
