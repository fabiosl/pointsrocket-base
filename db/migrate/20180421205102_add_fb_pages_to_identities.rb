class AddFbPagesToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :fb_pages, :text
  end
end
