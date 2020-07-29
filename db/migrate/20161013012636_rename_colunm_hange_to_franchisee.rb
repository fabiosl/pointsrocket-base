class RenameColunmHangeToFranchisee < ActiveRecord::Migration
  def change
    rename_column :categories, :hange_to_franchisee, :change_to_franchisee
  end
end
