require 'test_data_querying'
require 'date'
require 'net/ping'

module SyncService
    @current_datetime = DateTime.now.strftime("%Y-%m-%d")
    @data_synced = 1
    @net_available_data_not_synced = 2
    @net_not_available = 3
    def self.check_sync_status
        sites = Site.where(enabled: 1)
        sites.each do |site|
            site_code = site[:site_code]
            date_last_synced = TestDataQuerying.last_sync_date(site_code)
            if date_last_synced.nil?
                date = 0
            else
                date = date_last_synced.strftime("%Y-%m-%d")
            end
            ipaddress = site[:ip_address]
            Rails.logger.info "Checking last synced date for #{site[:name]}"
            if date == @current_datetime
                SiteSyncFrequency.create(site_id: site[:id], last_sync: date_last_synced,remark_id: @data_synced)
            else
                Rails.logger.info "Last sync not today"
                Rails.logger.info "Checking Connectivity"
                if up?(ipaddress)
                    Rails.logger.info "Connection available"
                    SiteSyncFrequency.create(site_id: site[:id], last_sync: date_last_synced,remark_id: @net_available_data_not_synced)
                else
                    Rails.logger.info "Connection unavailable"
                    SiteSyncFrequency.create(site_id: site[:id], last_sync: date_last_synced,remark_id: @net_not_available)
                end
            end  
            Rails.logger.info "\n\n"
        end
    end

    def self.up?(host)
        check = Net::Ping::External.new(host)
        check.ping?
    end
end