class CreateRelationshipBetwennStepStepTypes < ActiveRecord::Migration
  def change
    add_column :steps, :step_type_id, :integer
  end
end
