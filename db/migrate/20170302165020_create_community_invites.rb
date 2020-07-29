class CreateCommunityInvites < ActiveRecord::Migration
  def change
    create_table :community_invites do |t|
      t.references :user, index: true
      t.references :domain, index: true
      t.string :status

      t.timestamps
    end
  end
end
