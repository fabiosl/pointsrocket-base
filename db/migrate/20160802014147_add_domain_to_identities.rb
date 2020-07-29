class AddDomainToIdentities < ActiveRecord::Migration
  def change
    add_reference :identities, :domain, index: true
  end
end
