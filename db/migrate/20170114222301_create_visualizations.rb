class CreateVisualizations < ActiveRecord::Migration
  def change
    create_table :visualizations do |t|
      t.integer :user_id
      t.integer :broadcast_id

      t.timestamps
    end
  end
end
