class AddPositionToStepQuestion < ActiveRecord::Migration
  def change
    add_column :step_questions, :position, :integer
  end
end
