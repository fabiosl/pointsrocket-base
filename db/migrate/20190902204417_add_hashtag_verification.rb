class AddHashtagVerification < ActiveRecord::Migration
  def change
    add_column :domains, :only_registered_hashtags, :boolean, default: false
  end
end
