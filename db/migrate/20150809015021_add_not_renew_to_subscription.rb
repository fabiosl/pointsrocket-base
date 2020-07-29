class AddNotRenewToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :not_renew, :boolean, default: false
  end
end
