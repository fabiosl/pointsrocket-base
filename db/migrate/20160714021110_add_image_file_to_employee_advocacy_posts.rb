class AddImageFileToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_posts, :image_file, :string
  end
end
