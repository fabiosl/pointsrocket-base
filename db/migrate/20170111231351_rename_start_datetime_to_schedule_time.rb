class RenameStartDatetimeToScheduleTime < ActiveRecord::Migration
  def change
    rename_column :broadcasts, :start_datetime, :schedule_time
  end
end
