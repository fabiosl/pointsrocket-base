class CreateExternalActions < ActiveRecord::Migration
  def change
    create_table :external_actions do |t|
      t.text :text

      t.timestamps
    end
  end
end
