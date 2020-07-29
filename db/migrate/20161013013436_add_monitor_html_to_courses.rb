class AddMonitorHtmlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :monitor_html, :text
  end
end
