class CreateFranchisees < ActiveRecord::Migration
  def change
    create_table :franchisees do |t|
      t.string :token
      t.string :logo
      t.string :name
      t.references :domain, index: true

      t.timestamps
    end
  end
end
