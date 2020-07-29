class AddVideoToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_posts, :video, :string
  end
end
