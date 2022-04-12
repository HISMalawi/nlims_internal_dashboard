class RenameStatusToLastSyncInSiteSyncFrequency < ActiveRecord::Migration[6.1]
  def change
    rename_column :site_sync_frequencies, :status, :last_sync
  end
end
