class AddCssToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :css, :string
  end
end
