class AddInstagramPointsToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_posts, :instagram_points, :integer, default: 0
  end
end
