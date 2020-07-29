class AddPhoneBirthdateAndCpfToUser < ActiveRecord::Migration
  def change
    add_column :users, :cpf, :string
    add_column :users, :phone, :string
    add_column :users, :birthdate, :datetime
  end
end
