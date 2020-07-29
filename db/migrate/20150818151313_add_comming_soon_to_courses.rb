class AddCommingSoonToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :comming_soon, :boolean, default: false
  end
end
