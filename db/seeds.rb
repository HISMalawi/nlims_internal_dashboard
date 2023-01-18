require 'add_site_service'

# Remarks
Remark.create(remark: 'Data Synced')
Remark.create(remark: 'Network Available Data Not Synced')
Remark.create(remark: 'Network UnAvailable')

# Sites enabled
file_sites = JSON.parse(File.read(Rails.root.join('public','labs.json')))
AddSiteService.seed_sites(file_sites)
