class AddQuestionToUpvote < ActiveRecord::Migration
  def change
    add_reference :upvotes, :question, index: true
  end
end
