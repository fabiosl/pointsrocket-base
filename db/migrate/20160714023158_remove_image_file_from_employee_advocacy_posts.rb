class RemoveImageFileFromEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    remove_column :employee_advocacy_posts, :image_file
  end
end
