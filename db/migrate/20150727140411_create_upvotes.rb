class CreateUpvotes < ActiveRecord::Migration
  def change
    create_table :upvotes do |t|
      t.references :user, index: true
      t.references :answer, index: true
    end
  end
end
