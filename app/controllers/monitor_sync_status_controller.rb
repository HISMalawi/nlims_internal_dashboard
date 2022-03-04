require 'add_site_service'
require 'status_query_service'
require 'json'

class MonitorSyncStatusController < ApplicationController
    def add_site
        if request.post?
            AddSiteService.add_new_site(params)
            render template: 'monitor_sync_status/add_new_site'
        else
            render template: 'monitor_sync_status/add_new_site'
        end
    end
    
    def sync_statuses
        @sites = Site.where(enabled: 1)
        @x_problematic_sites = StatusQueryService.x_problematic_sites(15,30)
        today_sync_stats = StatusQueryService.today_sync_stats
        @get_sync_statuses_past_30_days = StatusQueryService.sync_statuses_past_x_days(30)
        get_sync_statuses_overview_30_days = StatusQueryService.sync_statuses_overview_x_days(30)
        @today_stats = {
            synced: 0,
            unsynced: 0
        }
        today_sync_stats.each do |status|
            if status.remark_id == 1
                @today_stats[:synced] = @today_stats[:synced] + status.count
            else
                @today_stats[:unsynced] = @today_stats[:unsynced] + status.count
            end
        end
        @overview_stats = {
            synced: 0,
            no_network: 0,
            net_avail_no_sync: 0
        }
        get_sync_statuses_overview_30_days.each do |status|
            if status.remark_id == 1
                @overview_stats[:synced] = @overview_stats[:synced] + status.count
            elsif status.remark_id == 2
                @overview_stats[:net_avail_no_sync] = @overview_stats[:net_avail_no_sync] + status.count
            else
                @overview_stats[:no_network] = @overview_stats[:no_network] + status.count
            end
        end
        render template: 'monitor_sync_status/site_status'       
    end

    def site_sync_details
      if request.post?
        puts "============================"
        month_year = params[:month].split("-")
        month = month_year[1]
        year = month_year[0]
        @monthly_sync = StatusQueryService.monthly_sync_status(month,year)
        puts @monthly_sync[0].remark
        puts month 
        puts year
        puts "============================"
      end

      @site_name = request.path_parameters[:site_name]
      site_code = request.path_parameters[:site_code]

      per_site_sync_status = StatusQueryService.per_site_sync_status(@site_name, site_code,30)
      @per_site_sync_status = {
        synced: 0,
        unsynced: 0
    	}
      per_site_sync_status.each do |status|
				if status.remark_id == 1
						@per_site_sync_status[:synced] = @per_site_sync_status[:synced] + status.count
				else
						@per_site_sync_status[:unsynced] = @per_site_sync_status[:unsynced] + status.count
				end
      end

			per_site_sync_statuses_past_x_days = StatusQueryService.per_site_sync_statuses_past_x_days(@site_name,site_code,30)
			@per_site_sync_remarks = per_site_sync_statuses_past_x_days
			@per_site_sync_statuses_past_x_days = []
      per_site_sync_statuses_past_x_days.each do |status|
				per_site_sync_statuses_past_x_days_hash = { 
					status: '',
					date: ''
    		}
				if status.remark_id == 1
						per_site_sync_statuses_past_x_days_hash[:status] = 'Synced'
						per_site_sync_statuses_past_x_days_hash[:date] = status[:date]
				else
					per_site_sync_statuses_past_x_days_hash[:status] = 'Unsynced'
					per_site_sync_statuses_past_x_days_hash[:date] = status[:date]
				end
				@per_site_sync_statuses_past_x_days.push(per_site_sync_statuses_past_x_days_hash)
      end

			per_site_sync_statuses_overview_x_days = StatusQueryService.per_site_sync_statuses_overview_x_days(@site_name, site_code,30)
			puts per_site_sync_statuses_overview_x_days.to_json
			@per_site_sync_statuses_overview_x_days = {
				synced: 0,
				no_network: 0,
				net_avail_no_sync: 0
			}
			per_site_sync_statuses_overview_x_days.each do |status|
				if status.remark_id == 1
						@per_site_sync_statuses_overview_x_days[:synced] = @per_site_sync_statuses_overview_x_days[:synced] + status.count
				elsif status.remark_id == 2
						@per_site_sync_statuses_overview_x_days[:net_avail_no_sync] = @per_site_sync_statuses_overview_x_days[:net_avail_no_sync] + status.count
				else
						@per_site_sync_statuses_overview_x_days[:no_network] = @per_site_sync_statuses_overview_x_days[:no_network] + status.count
				end
			end
			puts per_site_sync_statuses_past_x_days.to_json
      render template: 'monitor_sync_status/site_details'
    end
end