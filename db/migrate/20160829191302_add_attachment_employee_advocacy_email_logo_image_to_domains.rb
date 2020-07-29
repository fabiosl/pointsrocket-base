class AddAttachmentEmployeeAdvocacyEmailLogoImageToDomains < ActiveRecord::Migration
  def self.up
    change_table :domains do |t|
      t.attachment :employee_advocacy_email_logo_image
    end
  end

  def self.down
    remove_attachment :domains, :employee_advocacy_email_logo_image
  end
end
