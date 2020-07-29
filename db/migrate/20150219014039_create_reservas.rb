class CreateReservas < ActiveRecord::Migration
  def change
    create_table :reservas do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :curso_landing, index: true

      t.timestamps
    end
  end
end
