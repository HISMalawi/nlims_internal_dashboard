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

    def self.trend_no_network(day)
        sql = "SELECT site_sync_frequencies.id, count(site_sync_frequencies.id) AS count, DATE(site_sync_frequencies.updated_at) AS date
            FROM site_sync_frequencies
            INNER JOIN sites on sites.id=site_sync_frequencies.site_id
            INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
            WHERE sites.enabled=1 AND remarks.id= 3 AND (DATE(site_sync_frequencies.updated_at) = (?))"
        SiteSyncFrequency.find_by_sql([sql,"#{day}"])
    end

    def self.trend_network_no_data(day)
        sql = "SELECT site_sync_frequencies.id, count(site_sync_frequencies.id) AS count, DATE(site_sync_frequencies.updated_at) AS date
            FROM site_sync_frequencies
            INNER JOIN sites on sites.id=site_sync_frequencies.site_id
            INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
            WHERE sites.enabled=1 AND remarks.id= 2 AND (DATE(site_sync_frequencies.updated_at) = (?))"
        SiteSyncFrequency.find_by_sql([sql,"#{day}"])
    end

    def self.trend_synced(day)
        sql = "SELECT site_sync_frequencies.id, count(site_sync_frequencies.id) AS count, DATE(site_sync_frequencies.updated_at) AS date
            FROM site_sync_frequencies
            INNER JOIN sites on sites.id=site_sync_frequencies.site_id
            INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
            WHERE sites.enabled=1 AND remarks.id= 1 AND (DATE(site_sync_frequencies.updated_at) = (?))"
        SiteSyncFrequency.find_by_sql([sql,"#{day}"])
    end

    def self.trend_with_no_network(x_days)
        hash = Hash.new
        days = get_past_days(x_days)
        days.each do |day|
            trend = trend_no_network(day)[0]
            if trend.nil?
                hash[day] = 0
            else
                hash[day] = trend[:count]
            end
        end
        hash
    end

    def self.trend_network_but_no_data(x_days)
        hash = Hash.new
        days = get_past_days(x_days)
        days.each do |day|
            trend = trend_network_no_data(day)[0]
            if trend.nil?
                hash[day] = 0
            else
                hash[day] = trend[:count]
            end
        end
        hash
    end

    def self.trend_synced_data(x_days)
        hash = Hash.new
        days = get_past_days(x_days)
        days.each do |day|
            trend = trend_synced(day)[0]
            if trend.nil?
                hash[day] = 0
            else
                hash[day] = trend[:count]
            end
        end
        hash
    end



    # def self.all_sync_statuses
    #     sql = "SELECT site_sync_frequencies.id AS id, sites.*, remarks.remark, site_sync_frequencies.last_sync,site_sync_frequencies.created_at AS recent_check
    #             FROM site_sync_frequencies
    #             INNER JOIN sites on sites.id=site_sync_frequencies.site_id
    #             INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
    #             WHERE sites.enabled=1"
    #     SiteSyncFrequency.find_by_sql(sql)
    # end
    # {
        # no_data: [],
        # no_network: [],
        # synced: []
    # }
    #  


    
    

    # def self.remark_counts
    #     sql = "SELECT count(site_sync_frequencies.id) AS count, remarks.remark FROM site_sync_frequencies
    #             INNER JOIN sites on sites.id=site_sync_frequencies.site_id
    #             INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
    #             WHERE sites.enabled=1
    #             GROUP BY remarks.remark"
    #     SiteSyncFrequency.find_by_sql(sql)
    # end

    # def self.monthly_sync_status(month,year)
    #     sql = "SELECT count(site_sync_frequencies.id) AS count, remarks.remark FROM site_sync_frequencies
    #             INNER JOIN sites on sites.id=site_sync_frequencies.site_id
    #             INNER JOIN remarks on remarks.id=site_sync_frequencies.remark_id
    #             WHERE sites.enabled=1 AND substr(site_sync_frequencies.updated_at,1,4) = '#{year}' AND substr(site_sync_frequencies.updated_at,6,2) ='#{month}'
    #             GROUP BY remarks.remark"
    #     SiteSyncFrequency.find_by_sql(sql)
    # end
end