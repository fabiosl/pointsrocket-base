class CreateRelationshipBetwennStepStepTypes2 < ActiveRecord::Migration
  def change
    add_column :steps, :chapter_id, :integer
  end
end
