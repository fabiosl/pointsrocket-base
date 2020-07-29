# This migration comes from trivias (originally 20160328020149)
class CreateTriviasOptions < ActiveRecord::Migration
  def change
    create_table :trivias_options do |t|
      t.string :name
      t.boolean :correct
      t.references :question, index: true

      t.timestamps
    end
  end
end