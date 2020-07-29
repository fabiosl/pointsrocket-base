class AddUserToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_reference :employee_advocacy_posts, :user, index: true
  end
end
