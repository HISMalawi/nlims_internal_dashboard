require 'add_site_service'

class MonitorSyncStatusController < ApplicationController
    def sites
        Site.all
    end
    def add_site
        if request.post?
            AddSiteService.add_new_site(params)
            render template: 'monitor_sync_status/add_new_site'
        else
            render template: 'monitor_sync_status/add_new_site'
        end
    end
end