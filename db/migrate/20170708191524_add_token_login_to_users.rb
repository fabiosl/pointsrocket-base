class AddTokenLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_login, :string
  end
end
