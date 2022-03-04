require 'test_data_querying'
require 'date'
require 'net/ping'

module SyncService
    Rails.logger = Logger.new(STDOUT)
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
            site_name = site[:name]
            sync_freq_today = check_today_service_run(site_code, site_name, @current_datetime)
            Rails.logger.info sync_freq_today
            Rails.logger.info "Checking last sync frequency date for #{site[:name]} today"
            if !sync_freq_today.nil?
                Rails.logger.info "Last sync frequency for today found"
                if date == @current_datetime
                    Rails.logger.info "Updating last sync"
                    SiteSyncFrequency.update(sync_freq_today.id,site_id: site[:id], last_sync: date_last_synced,remark_id: @data_synced, updated_at: DateTime.now)
                else
                    Rails.logger.info "Update: Last sync not today"
                    Rails.logger.info "Update: Checking Connectivity"
                    if up?(ipaddress)
                        Rails.logger.info "Update: Connection available"
                        SiteSyncFrequency.update(sync_freq_today.id,site_id: site[:id], last_sync: date_last_synced,remark_id: @net_available_data_not_synced, updated_at: DateTime.now)
                    else
                        Rails.logger.info "Update: Connection unavailable"
                        SiteSyncFrequency.update(sync_freq_today.id,site_id: site[:id], last_sync: date_last_synced,remark_id: @net_not_available, updated_at: DateTime.now)
                    end
                end
            else
                Rails.logger.info "Last sync frequency record for today Not Found"
                Rails.logger.info "Create: Checking last synced date for #{site[:name]}"
                if date == @current_datetime
                    SiteSyncFrequency.create(site_id: site[:id], last_sync: date_last_synced,remark_id: @data_synced)
                else
                    Rails.logger.info "Create: Last sync not today"
                    Rails.logger.info "Create: Checking Connectivity"
                    if up?(ipaddress)
                        Rails.logger.info "Create: Connection available"
                        SiteSyncFrequency.create(site_id: site[:id], last_sync: date_last_synced,remark_id: @net_available_data_not_synced)
                    else
                        Rails.logger.info "Create: Connection unavailable"
                        SiteSyncFrequency.create(site_id: site[:id], last_sync: date_last_synced,remark_id: @net_not_available)
                    end
                end  
            end
            
            Rails.logger.info "\n\n"
        end
    end

    def self.up?(host)
        check = Net::Ping::External.new(host)
        check.ping?
    end

    def self.check_today_service_run(site_code, site_name, date)
        sql = "SELECT site_sync_frequencies.* FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id
                WHERE sites.enabled=1 AND (DATE(site_sync_frequencies.updated_at) = '#{date}') AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
                ORDER BY DATE(site_sync_frequencies.id) DESC LIMIT 1"
        SiteSyncFrequency.find_by_sql(sql)[0]
    end
end