class AddDownloadPointsToEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    add_column :employee_advocacy_posts, :download_points, :integer, default: 0
  end
end
