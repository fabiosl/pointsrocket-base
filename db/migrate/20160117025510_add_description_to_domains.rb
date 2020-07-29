class AddDescriptionToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :description, :text
  end
end
