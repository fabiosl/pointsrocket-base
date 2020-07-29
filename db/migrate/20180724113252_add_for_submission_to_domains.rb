class AddForSubmissionToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :for_submission, :boolean, default: false
  end
end
