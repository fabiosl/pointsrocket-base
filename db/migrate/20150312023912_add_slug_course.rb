class AddSlugCourse < ActiveRecord::Migration
  def up
    add_column :courses, :slug, :string
  end

  def down
    remove_column :courses, :slug
  end
end
