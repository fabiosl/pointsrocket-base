class AddCancelReasonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cancel_reason, :string
  end
end
