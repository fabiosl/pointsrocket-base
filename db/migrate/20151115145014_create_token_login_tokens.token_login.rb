# This migration comes from token_login (originally 20151114193803)
class CreateTokenLoginTokens < ActiveRecord::Migration
  def change
    create_table :token_login_tokens do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
