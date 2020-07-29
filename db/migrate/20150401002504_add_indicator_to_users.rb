class AddIndicatorToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :indicator, index: true
  end
end
