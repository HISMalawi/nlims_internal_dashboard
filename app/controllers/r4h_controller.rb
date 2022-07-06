class R4hController < ApplicationController
    def index 
        @orders = Speciman.find_by_sql("SELECT COUNT(*) AS total_orders FROM specimen")[0][:total_orders]
        @orders_collected = Speciman.find_by_sql("SELECT COUNT(*) AS orders_collected FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            WHERE sdt.name='sample_dispatched_from_facility'")[0][:orders_collected]
        @orders_delivered_at_molecular = Speciman.find_by_sql("SELECT COUNT(*) AS orders_delivered_at_molecular FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            WHERE sdt.name='delivering_samples_to_molecular_lab'")[0][:orders_delivered_at_molecular]
        @orders_delivered_at_dho = Speciman.find_by_sql("SELECT COUNT(*) AS orders_delivered_at_dho FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            WHERE sdt.name='delivering_samples_to_district_hub'")[0][:orders_delivered_at_dho]
        @dispatch_results_at_molecular = Speciman.find_by_sql("SELECT COUNT(*) AS dispatch_results_at_molecular FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            WHERE sdt.name='delivering_results_to_facility'")[0][:dispatch_results_at_molecular]
    end

    def total_orders
        @total_orders = Speciman.find_by_sql("SELECT sending_facility AS facility,  COUNT(*) AS total_orders FROM
              specimen GROUP BY(sending_facility)")
    end
    
    def orders_collected
        @orders_collected = Speciman.find_by_sql("SELECT sp.sending_facility AS facility, COUNT(*) AS orders_collected FROM
            specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN
            specimen sp ON sp.tracking_number = sd.tracking_number WHERE sdt.name = 'sample_dispatched_from_facility'
            GROUP BY(sp.sending_facility);")
    end
    
    def orders_delivered_at_dho
        @orders_delivered_at_dho = Speciman.find_by_sql("SELECT sp.district AS district, sp.sending_facility AS facility, COUNT(*) AS orders_delivered_at_dho
            FROM specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN
            specimen sp ON sp.tracking_number = sd.tracking_number WHERE sdt.name = 'delivering_samples_to_district_hub'
            GROUP BY (sp.sending_facility)")
    end

    def orders_delivered_at_molecular_lab
        @orders_delivered_at_molecular_lab = Speciman.find_by_sql("SELECT sp.target_lab AS target_lab, sp.sending_facility AS facility, COUNT(*) AS orders_delivered_at_molecular_lab
            FROM specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN
            specimen sp ON sp.tracking_number = sd.tracking_number WHERE sdt.name = 'delivering_samples_to_molecular_lab'
            GROUP BY (sp.sending_facility)")
    end
end
