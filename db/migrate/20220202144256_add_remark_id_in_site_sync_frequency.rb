class AddRemarkIdInSiteSyncFrequency < ActiveRecord::Migration[6.1]
  def change
    add_column :site_sync_frequencies, :remark_id, :int
  end
end
