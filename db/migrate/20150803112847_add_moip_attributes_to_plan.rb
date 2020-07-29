class AddMoipAttributesToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :amount, :integer
    add_column :plans, :setup_fee, :integer
    add_column :plans, :interval_unit, :string
    add_column :plans, :status, :string
    add_column :plans, :description, :string
    add_column :plans, :billing_cycles, :integer
    add_column :plans, :trial_days, :integer
    add_column :plans, :trial_hold_setup_fee, :integer
  end
end
