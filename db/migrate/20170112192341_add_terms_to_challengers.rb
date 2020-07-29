class AddTermsToChallengers < ActiveRecord::Migration
  def change
    add_column :challenges, :terms, :text
  end
end
