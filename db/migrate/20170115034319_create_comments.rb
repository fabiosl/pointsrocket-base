class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.references :parent, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
