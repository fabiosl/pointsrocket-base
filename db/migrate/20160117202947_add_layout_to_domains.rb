class AddLayoutToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :layout, :string
  end
end
