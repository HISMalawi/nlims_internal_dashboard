require 'date'
module R4hDashboard
  module Utils
    module General
      class << self 
        def central_hospitals
          c_hospitals = ['Kamuzu Central Hospital','Kamuzu Central Hospital Laboratory', 'Mzuzu Central Hospital',
            'Mzuzu Central Hospital Laboratory', 'Queen Elizabeth Central Hospital', 'Queen Elizabeth Central Hospital Laboratory',
            'Queen Elizabeth (QECH) Central Hospital', 'Zomba Central Hospital']
          return "('" << c_hospitals.join("','") << "')"
        end

        def start_date
          return '2022-11-28'
        end 
        
        def end_date
          return Date.today.strftime('%Y-%m-%d').to_s
        end
      end 
    end
  end
end