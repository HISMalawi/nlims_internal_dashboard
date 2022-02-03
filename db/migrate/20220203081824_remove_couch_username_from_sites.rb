class RemoveCouchUsernameFromSites < ActiveRecord::Migration[6.1]
  def change
    remove_column :sites, :couch_username
  end
end
