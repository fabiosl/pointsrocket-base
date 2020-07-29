class AddStopReasonToTriviasPlays < ActiveRecord::Migration
  def change
    add_column :trivias_plays, :stop_reason, :string
    add_index :trivias_plays, :stop_reason
  end
end
