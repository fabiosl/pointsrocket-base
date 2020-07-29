class ChangeEmployeeAdvocacyPostsTitle < ActiveRecord::Migration
  def change
    change_column :employee_advocacy_posts, :title, :string, :limit => 10_000
  end
end
