class AddAllowContentReportToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :allow_content_report, :boolean, default: false
  end
end
