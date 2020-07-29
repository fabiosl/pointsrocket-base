class CreateEmployeeAdvocacyShares < ActiveRecord::Migration
  def change
    create_table :employee_advocacy_shares do |t|
      t.references :employee_advocacy_post, index: true
      t.references :user, index: true
      t.string :social_network, index: true
      t.text :user_content
      t.datetime :schedule_date
      t.datetime :shared_date
      t.string :token

      t.timestamps
    end
  end
end
