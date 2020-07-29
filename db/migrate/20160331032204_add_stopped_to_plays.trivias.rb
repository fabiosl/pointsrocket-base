# This migration comes from trivias (originally 20160331031942)
class AddStoppedToPlays < ActiveRecord::Migration
  def change
    add_column :trivias_plays, :stopped, :boolean
    add_index :trivias_plays, :stopped
  end
end
