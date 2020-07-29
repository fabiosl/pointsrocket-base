class AddStepTypeToStep < ActiveRecord::Migration
  def change
    add_column :steps, :step_type, :string, index: true
    remove_column :steps, :step_type_id
  end
end
