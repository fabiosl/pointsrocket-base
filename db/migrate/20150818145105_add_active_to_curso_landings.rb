class AddActiveToCursoLandings < ActiveRecord::Migration
  def change
    add_column :curso_landings, :active, :boolean, default: false
  end
end
