class CreateCourseTrails < ActiveRecord::Migration
  def change
    create_table :course_trails do |t|
      t.references :course, index: true
      t.references :trail, index: true

      t.timestamps
    end
  end
end
