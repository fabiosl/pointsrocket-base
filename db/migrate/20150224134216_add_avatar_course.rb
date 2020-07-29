class AddAvatarCourse < ActiveRecord::Migration
  def change
    add_attachment :courses, :avatar
  end
end
