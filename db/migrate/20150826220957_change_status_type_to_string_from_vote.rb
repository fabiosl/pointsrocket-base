class ChangeStatusTypeToStringFromVote < ActiveRecord::Migration
  def change
    change_column :votes, :status, :string, index: true
  end
end
