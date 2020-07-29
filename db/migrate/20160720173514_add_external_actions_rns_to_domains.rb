class AddExternalActionsRnsToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :external_actions_rns, :string
  end
end
