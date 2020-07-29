class CreateUserCourses < ActiveRecord::Migration
  def up
    create_table :user_courses do |t|
      t.references :user
      t.references :course
      t.string     :status
      t.string     :initialized_chapters, array: true, default: []
      t.string     :initialized_steps, array: true, default: []

      t.timestamps
    end
  end

  def down
    drop_table :user_courses
  end
end
