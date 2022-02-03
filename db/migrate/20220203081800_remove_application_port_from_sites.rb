class RemoveApplicationPortFromSites < ActiveRecord::Migration[6.1]
  def change
    remove_column :sites, :application_port
  end
end
