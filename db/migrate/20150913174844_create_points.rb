class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :user, index: true
      t.references :pointable, index: true, polymorphic: true
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
