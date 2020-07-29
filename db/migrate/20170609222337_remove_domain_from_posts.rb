class RemoveDomainFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :domain_id, :integer
  end
end
