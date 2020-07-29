class AddHintToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :hint, :string
  end
end
