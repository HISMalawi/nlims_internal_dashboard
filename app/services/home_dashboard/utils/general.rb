require 'date'
module HomeDashboard
  module Utils
    module General
      class << self 
        def today
          return Date.today.strftime('%Y-%m-%d').to_s
        end
        
        def sites 
          @labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
          @genexpert_labs = YAML.load_file "#{Rails.root}/public/genexpert_labs.json"
          {
            molecular_labs: @labs,
            genexpert_labs: @genexpert_labs
          }
        end
      end 
    end
  end
end