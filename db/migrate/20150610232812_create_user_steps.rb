class CreateUserSteps < ActiveRecord::Migration
  def change
    create_table :user_steps do |t|
      t.references :user, index: true
      t.references :step, index: true

      t.timestamps
    end
  end
end
