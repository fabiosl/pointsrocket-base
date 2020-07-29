class AddEmployeeAdvocacyPostJsonToEmployeeAdvocacyShares < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_shares, :post_json, :text
  end
end
