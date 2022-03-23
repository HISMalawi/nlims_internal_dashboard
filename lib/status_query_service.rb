require 'date'
module StatusQueryService
    def self.today_sync_stats
        today = Date.today
        sql = "SELECT count(site_sync_frequencies.id) AS count, site_sync_frequencies.remark_id FROM site_sync_frequencies
            INNER JOIN sites on sites.id=site_sync_frequencies.site_id
            INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
            WHERE sites.enabled=1 AND substr(site_sync_frequencies.updated_at,1,10) = '#{today}'
            GROUP BY remarks.remark"
        SiteSyncFrequency.find_by_sql(sql)
    end

    def self.sync_statuses_past_x_days(x_days)
        sql = "SELECT site_sync_frequencies.id, remarks.remark, sites.site_code, sites.name AS site_name,DATE(site_sync_frequencies.updated_at) AS date
                FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id
                INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
                WHERE sites.enabled=1 AND (DATE(site_sync_frequencies.updated_at) IN (?))
                ORDER BY DATE(site_sync_frequencies.updated_at) DESC, sites.name"
        SiteSyncFrequency.find_by_sql([sql,get_past_days(x_days)])
    end
    def self.get_past_days(number_of_days)
        days = []
        for i in 0..number_of_days
            days.push("#{(Date.today - i).to_date}")
        end
        days
    end

    def self.sync_statuses_overview_today
        today = Date.today
        sql = "SELECT count(site_sync_frequencies.id) AS count, site_sync_frequencies.remark_id FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id
                INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
                WHERE sites.enabled=1 AND substr(site_sync_frequencies.updated_at,1,10) = '#{today}'
                GROUP BY remarks.remark"       
        SiteSyncFrequency.find_by_sql(sql)
    end

    def self.x_problematic_sites(x_sites,x_days)
        sql = "SELECT count(site_sync_frequencies.id) AS count,sites.name, sites.site_code FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id
                WHERE sites.enabled=1 AND (site_sync_frequencies.remark_id = 2 OR site_sync_frequencies.remark_id = 3) AND (DATE(site_sync_frequencies.updated_at) IN (?))
                GROUP BY sites.name ORDER BY count(site_sync_frequencies.id) DESC LIMIT #{x_sites}"
        SiteSyncFrequency.find_by_sql([sql,get_past_days(x_days)])
    end

    def self.per_site_sync_status(site_name, site_code, x_days: '', month: '', year: '') 
        sql = "SELECT count(site_sync_frequencies.id) AS count, site_sync_frequencies.remark_id AS remark_id, site_sync_frequencies.id AS id, sites.site_code, sites.name FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id "
        if month != '' and year != ''
            condition = "WHERE sites.enabled=1 AND substr(site_sync_frequencies.updated_at,1,4) = '#{year}' AND substr(site_sync_frequencies.updated_at,6,2) ='#{month}'
                AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
                GROUP BY site_sync_frequencies.remark_id"
            sql += condition
            SiteSyncFrequency.find_by_sql(sql)
        else
            condition = "WHERE sites.enabled=1 AND (DATE(site_sync_frequencies.updated_at) IN (?)) AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
            GROUP BY site_sync_frequencies.remark_id"
            sql += condition
            SiteSyncFrequency.find_by_sql([sql,get_past_days(x_days)])
        end
    end

    def self.per_site_sync_statuses_past_x_days(site_name, site_code, x_days: '', month: '', year: '')
        sql = "SELECT site_sync_frequencies.id AS id, site_sync_frequencies.remark_id AS remark_id, remarks.remark,DATE(site_sync_frequencies.updated_at) AS date
                FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id
                INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id "
        if month != '' and year != ''
            condition = "WHERE sites.enabled=1 AND substr(site_sync_frequencies.updated_at,1,4) = '#{year}' AND substr(site_sync_frequencies.updated_at,6,2) ='#{month}'
                AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
                ORDER BY DATE(site_sync_frequencies.updated_at) DESC"
            sql += condition
            SiteSyncFrequency.find_by_sql(sql)
        else
            condition = "WHERE sites.enabled=1 AND (DATE(site_sync_frequencies.updated_at) IN (?)) AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
            ORDER BY DATE(site_sync_frequencies.updated_at) DESC"
            sql += condition
            SiteSyncFrequency.find_by_sql([sql,get_past_days(x_days)])
        end
    end

    def self.per_site_sync_statuses_overview_x_days(site_name, site_code, x_days: '', month: '', year: '')
        sql = "SELECT count(site_sync_frequencies.id) AS count, site_sync_frequencies.remark_id AS remark_id, site_sync_frequencies.id FROM site_sync_frequencies
                INNER JOIN sites on sites.id=site_sync_frequencies.site_id "
                
        if month != '' and year != ''
            condition = "WHERE sites.enabled=1 AND substr(site_sync_frequencies.updated_at,1,4) = '#{year}' AND substr(site_sync_frequencies.updated_at,6,2) ='#{month}'
                AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
                GROUP BY site_sync_frequencies.remark_id"
            sql += condition
            SiteSyncFrequency.find_by_sql(sql)
        else
            condition = "WHERE sites.enabled=1 AND (DATE(site_sync_frequencies.updated_at) IN (?)) AND (sites.name='#{site_name}' AND sites.site_code='#{site_code}')
                GROUP BY site_sync_frequencies.remark_id" 
            sql += condition
            SiteSyncFrequency.find_by_sql([sql,get_past_days(x_days)])
        end      
    end

    def self.remark_past_xdays(x_days)
        sql = "SELECT count(site_sync_frequencies.id) AS count, site_sync_frequencies.remark_id FROM site_sync_frequencies
            INNER JOIN sites on sites.id=site_sync_frequencies.site_id
            INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
            WHERE sites.enabled=1
            GROUP BY remarks.remark"
        SiteSyncFrequency.find_by_sql([sql,get_past_days(x_days)])
     end

    def self.trend_record(day, remark_id, remark_id2)
        if remark_id2 == 1
            condition = "WHERE sites.enabled=1 AND remarks.id=#{remark_id} AND (DATE(site_sync_frequencies.updated_at) = (?))"
        else
            condition ="WHERE sites.enabled=1 AND (remarks.id=#{remark_id} OR remarks.id=#{remark_id2}) AND (DATE(site_sync_frequencies.updated_at) = (?))"
        end
        sql = "SELECT site_sync_frequencies.id, count(site_sync_frequencies.id) AS count, DATE(site_sync_frequencies.updated_at) AS date
            FROM site_sync_frequencies
            INNER JOIN sites on sites.id=site_sync_frequencies.site_id
            INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id "
        sql = sql + condition
        SiteSyncFrequency.find_by_sql([sql,"#{day}"])
    end

    def self.format_trend(x_days, remark_id, remark_id2, callback)
        hash = Hash.new
        days = get_past_days(x_days)
        days.each do |day|
            trend = callback.call(day, remark_id, remark_id2)[0]
            if trend.nil?
                hash[day] = 0
            else
                hash[day] = trend[:count]
            end
        end
        hash
    end

    def self.trends
        hash = Hash.new
        sync = 1
        net_no_data = 2
        no_net = 3
        days = 30
        # no_network = format_trend(30, 3, method(:trend_record))
        # no_data = format_trend(30, 2, method(:trend_record))
        # synced = format_trend(30, 1, method(:trend_record))
        unsynced = format_trend(days, net_no_data, no_net, method(:trend_record))
        synced = format_trend(days, sync, sync, method(:trend_record))
        hash[:unsynced] = unsynced
        hash[:synced] = synced
        # hash[:no_network] = no_network
        # hash[:no_data] = no_data
        # hash[:synced] = synced
        hash
    end
end