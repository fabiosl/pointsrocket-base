class AddCategoryToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :category, :string
  end
end
