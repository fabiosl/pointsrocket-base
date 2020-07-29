class AddHasSubmitedPaymentFormToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_submited_payment_form, :boolean, default: false
  end
end
