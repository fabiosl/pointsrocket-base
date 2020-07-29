class AddTypeToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :type, :string, index: true
  end
end
