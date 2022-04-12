class RenameSiteToSideIdInSiteSyncFrequency < ActiveRecord::Migration[6.1]
  def change
    rename_column :site_sync_frequencies, :site, :site_id
  end
end