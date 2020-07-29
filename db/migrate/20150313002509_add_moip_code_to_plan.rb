class AddMoipCodeToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :moip_code, :string
  end
end
