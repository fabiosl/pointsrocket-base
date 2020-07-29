class AddArchiveToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :archive, :string
    add_column :answers, :archive, :string
  end
end
