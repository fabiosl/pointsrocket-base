class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :user, index: true
      t.string :device_type
      t.string :push_notification_token
      t.string :device_id

      t.timestamps
    end
  end
end
