# This migration comes from trivias (originally 20160401012614)
class AddStopReasonToTriviasPlays < ActiveRecord::Migration
  def change
    add_column :trivias_plays, :stop_reason, :string
    add_index :trivias_plays, :stop_reason
  end
end
