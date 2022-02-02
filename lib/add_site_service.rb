module AddSiteService
    # file_sites = JSON.parse(File.read(Rails.root.join('public','labs.json')))
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
        Site.create(params)
    end

    def self.update_site(params, id)
        site = Site.where(id: id).first
        site.update(params)
    end
end