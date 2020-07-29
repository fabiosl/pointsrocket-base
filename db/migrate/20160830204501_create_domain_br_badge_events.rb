class CreateDomainBrBadgeEvents < ActiveRecord::Migration
  def change
    create_table :domain_br_badge_events do |t|
      t.references :domain, index: true
      t.string :event
      t.string :br_badge

      t.timestamps
    end
  end
end
