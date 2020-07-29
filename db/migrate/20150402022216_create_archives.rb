class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :name
      t.string :archive
      t.references :archiveable, polymorphic: true

      t.timestamps
    end
  end
end
