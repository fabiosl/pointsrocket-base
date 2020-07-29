class CreateBadgeUsers < ActiveRecord::Migration
  def change
    create_table :badge_users do |t|
      t.integer :user_id
      t.integer :badge_id

      t.timestamps
    end
  end
end
