class AddLogoToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :logo, :string
  end
end
