class AddAttachmentDashboardMenuImageContractToDomains < ActiveRecord::Migration
  def self.up
    change_table :domains do |t|
      t.attachment :dashboard_menu_image_contract
    end
  end

  def self.down
    remove_attachment :domains, :dashboard_menu_image_contract
  end
end
