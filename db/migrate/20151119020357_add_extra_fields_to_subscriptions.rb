class AddExtraFieldsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :active_until, :datetime
    add_column :subscriptions, :first_paid_day, :datetime
    add_column :subscriptions, :suspend_in, :datetime
    add_column :subscriptions, :suspended_in, :datetime
  end
end
