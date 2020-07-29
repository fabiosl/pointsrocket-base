# This migration comes from token_login_engine (originally 20151115185844)
class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :user, index: true
      t.string :key
      t.datetime :valid_until

      t.timestamps
    end
  end
end
