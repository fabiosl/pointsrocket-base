class AddDomainToExternalActions < ActiveRecord::Migration
  def change
    add_reference :external_actions, :domain, index: true
  end
end
