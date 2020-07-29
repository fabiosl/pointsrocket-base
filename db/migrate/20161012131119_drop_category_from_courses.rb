class DropCategoryFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :category_id
    remove_column :courses, :category_name
  end
end
