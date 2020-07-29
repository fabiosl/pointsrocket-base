class DropUserCourse < ActiveRecord::Migration
  def change
    drop_table :user_courses
  end
end
