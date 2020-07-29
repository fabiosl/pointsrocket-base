class DropPostImages < ActiveRecord::Migration
  def change
    drop_table :post_images
  end
end
