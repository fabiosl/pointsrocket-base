class RenameColumTypeToBadgeTypeFromBadges < ActiveRecord::Migration
  def change
    rename_column :badges, :type, :badge_type
  end
end
