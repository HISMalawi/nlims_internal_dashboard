class RenameHostAddressToIpAddressInSites < ActiveRecord::Migration[6.1]
  def change
    rename_column :sites, :host_address, :ip_address
  end
end
