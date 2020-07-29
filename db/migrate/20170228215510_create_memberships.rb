class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, index: true
      t.references :domain, index: true
      t.string :status
      t.integer :role, default: 0

      t.timestamps
    end
  end
end
