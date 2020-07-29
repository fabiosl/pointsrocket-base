class AddApnKeyToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :apn_key, :string
  end
end
