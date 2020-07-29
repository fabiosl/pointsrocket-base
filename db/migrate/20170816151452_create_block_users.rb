class CreateBlockUsers < ActiveRecord::Migration
  def change
    create_table :block_users do |t|
      t.references :blocker, index: true
      t.references :blocked, index: true

      t.timestamps
    end
  end
end
