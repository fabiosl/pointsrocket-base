class AddFieldsToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :name, :string
    add_column :domains, :has_indication, :boolean, default: false
    add_column :domains, :has_finantial, :boolean, default: false
    add_column :domains, :has_homepage, :boolean, default: false
    add_column :domains, :default, :boolean, default: false
  end
end
