class AddCopyrightToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :copyright, :string
  end
end
