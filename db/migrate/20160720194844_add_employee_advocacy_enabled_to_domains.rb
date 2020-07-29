class AddEmployeeAdvocacyEnabledToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :employee_advocacy_enabled, :boolean, default: false
  end
end
