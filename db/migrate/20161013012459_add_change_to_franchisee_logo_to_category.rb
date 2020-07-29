class AddChangeToFranchiseeLogoToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :hange_to_franchisee, :boolean, default: false
  end
end
