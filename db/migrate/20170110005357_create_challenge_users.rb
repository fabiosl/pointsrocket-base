class CreateChallengeUsers < ActiveRecord::Migration
  def change
    create_table :challenge_users do |t|
      t.references :challenge, index: true
      t.references :user, index: true
      t.string :status
      t.text :feedback
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
