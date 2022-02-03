class RemoveSyncStatusFromSites < ActiveRecord::Migration[6.1]
  def change
    remove_column :sites, :sync_status
  end
end
