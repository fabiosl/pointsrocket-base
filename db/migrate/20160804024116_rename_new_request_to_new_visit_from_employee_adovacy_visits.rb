class RenameNewRequestToNewVisitFromEmployeeAdovacyVisits < ActiveRecord::Migration
  def change
    rename_column :employee_advocacy_visits, :new_request, :new_visit
  end
end
