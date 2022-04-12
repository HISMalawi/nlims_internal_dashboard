module AddSiteService
    def self.seed_sites(sites)
        sites.each do |key, value|
            site = Site.where(name: key).take
            if site.nil?
                Site.create(name: key, host_address: value[0], site_code: value[1], x: value[3], y: value[2], district: value[4], region: value[5], enabled: 1)
            else
                site.update(host_address: value[0], site_code: value[1], enabled: 1)
            end
        end
    end

    def self.add_new_site(params)
        if params[:enabled]
            enable = 1
        else
            enable = 0
        end
        site = Site.where(name: params[:site_name]).take
        if site.nil?
            Site.create(name: params[:site_name].titleize, host_address: params[:host_address], site_code: params[:site_code].upcase, 
                x: params[:longitude], y: params[:latitude], district: params[:district].capitalize, region: params[:region].capitalize, 
                description: params[:description].titleize,enabled: enable)
        elsif site[:site_code] == params[:site_code]
            site.update(host_address: params[:host_address],enabled: enable)
        else 
            Site.create(name: params[:site_name].titleize, host_address: params[:host_address], site_code: params[:site_code].upcase, 
                x: params[:longitude], y: params[:latitude], district: params[:district].capitalize, region: params[:region].capitalize, 
                description: params[:description].titleize,enabled: enable)     
        end

    end

    def self.update_site(params, id)
        site = Site.where(id: id).first
        site.update(params)
    end
end