class CreateCursoLandings < ActiveRecord::Migration
  def change
    create_table :curso_landings do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
