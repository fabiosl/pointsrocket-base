class AddScoreDisabledToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :score_disabled, :boolean, default: false
  end
end
