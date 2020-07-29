class AddScoreToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :score, :integer, default: 0
  end
end
