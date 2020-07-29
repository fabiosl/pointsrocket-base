class AddPrivacyToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :privacy, :string, default: 'all'
  end
end
