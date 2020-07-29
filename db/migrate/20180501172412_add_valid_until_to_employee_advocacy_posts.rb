class AddValidUntilToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_posts, :valid_until, :datetime
  end
end
