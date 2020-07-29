class AddHashtagsToCoinUser < ActiveRecord::Migration
  def change
    add_column :coin_users, :hashtags, :text, array: true, default: []
  end
end
