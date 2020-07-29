class AddSocialJsonToEmployeeAdvocacyShares < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_shares, :social_json, :text
  end
end
