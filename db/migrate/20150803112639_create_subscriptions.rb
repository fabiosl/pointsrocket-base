class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.integer :moip_code
      t.string :status
      t.datetime :remote_creation_date
      t.integer :amount
      t.references :plan, index: true
      t.datetime :next_invoice_date
      t.datetime :trial_start_time
      t.datetime :trial_end_time

      t.timestamps
    end
  end
end
