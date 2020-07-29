class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :email
      t.string :name

      t.timestamps
    end
    add_index :newsletters, :email, unique: true
  end
end
