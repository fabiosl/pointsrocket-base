class AddCreatedOnMoipToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :created_on_moip, :boolean, default: false
  end
end
