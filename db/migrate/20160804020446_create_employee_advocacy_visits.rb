class CreateEmployeeAdvocacyVisits < ActiveRecord::Migration
  def change
    create_table :employee_advocacy_visits do |t|
      t.references :employee_advocacy_share, index: true
      t.boolean :new_request

      t.timestamps
    end
    add_index :employee_advocacy_visits, :new_request
  end
end
