class AddBadgeToChallengers < ActiveRecord::Migration
  def change
    add_reference :challenges, :badge, index: true
  end
end
