class ChangeColumnTypeForLastSyncInSiteFrequency < ActiveRecord::Migration[6.1]
  def change
    change_column :site_sync_frequencies, :last_sync, :datetime
  end
end
