class AddAfterSigninPathToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :after_signin_path, :string
  end
end
