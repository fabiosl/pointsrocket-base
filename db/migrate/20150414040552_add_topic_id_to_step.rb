class AddTopicIdToStep < ActiveRecord::Migration
  def change
    add_reference :steps, :topic, index: true
  end
end
