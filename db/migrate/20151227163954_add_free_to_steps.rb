class AddFreeToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :free, :boolean, default: false
  end
end
