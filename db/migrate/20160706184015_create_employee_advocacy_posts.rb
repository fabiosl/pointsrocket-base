class CreateEmployeeAdvocacyPosts < ActiveRecord::Migration
  def change
    create_table :employee_advocacy_posts do |t|
      t.boolean :active
      t.integer :facebook_points
      t.integer :twitter_points
      t.integer :linkedin_points
      t.string :title
      t.text :content
      t.string :url
      t.string :image

      t.timestamps
    end
  end
end
