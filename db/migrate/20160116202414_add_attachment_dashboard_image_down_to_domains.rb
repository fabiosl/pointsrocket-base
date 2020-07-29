class AddAttachmentDashboardImageDownToDomains < ActiveRecord::Migration
  def self.up
    change_table :domains do |t|
      t.attachment :dashboard_image_down
    end
  end

  def self.down
    remove_attachment :domains, :dashboard_image_down
  end
end
