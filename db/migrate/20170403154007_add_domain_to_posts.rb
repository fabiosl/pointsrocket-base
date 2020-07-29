class AddDomainToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :domain, index: true
  end
end
