class AddFolderToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_posts, :folder, :string
  end
end
