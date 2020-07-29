class AddWhereToPublishToEmployeeAdvocacyShares < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_shares, :where_to_publish, :string
  end
end
