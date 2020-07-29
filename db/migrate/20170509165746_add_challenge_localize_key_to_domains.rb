class AddChallengeLocalizeKeyToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :challenge_localize_key, :string
  end
end
