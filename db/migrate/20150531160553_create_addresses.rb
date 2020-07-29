class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.references :user, index: true

      t.timestamps
    end
  end
end
