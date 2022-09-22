class R4hController < ApplicationController
    $central_hospitals = ['Kamuzu Central Hospital','Kamuzu Central Hospital Laboratory', 'Mzuzu Central Hospital',
        'Mzuzu Central Hospital Laboratory', 'Queen Elizabeth Central Hospital', 'Queen Elizabeth Central Hospital Laboratory',
        'Queen Elizabeth (QECH) Central Hospital', 'Zomba Central Hospital']
    $sending_facility_not_in_central_hospitals = "sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')"
    def index
        @orders = Speciman.find_by_sql("SELECT COUNT(*) AS total_orders FROM specimen sp
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine' AND #{$sending_facility_not_in_central_hospitals}
        ")[0][:total_orders]
        @orders_collected = Speciman.find_by_sql("SELECT COUNT(*) AS orders_collected FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            INNER JOIN specimen sp ON sp.tracking_number=sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'
            AND sdt.name='sample_dispatched_from_facility' 
            AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')")[0][:orders_collected]
        @orders_delivered_at_molecular = Speciman.find_by_sql("SELECT COUNT(*) AS orders_delivered_at_molecular FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            INNER JOIN specimen sp ON sp.tracking_number=sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'
            AND sdt.name='delivering_samples_to_molecular_lab'
            AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')")[0][:orders_delivered_at_molecular]
        @orders_delivered_at_dho = Speciman.find_by_sql("SELECT COUNT(*) AS orders_delivered_at_dho FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            INNER JOIN specimen sp ON sp.tracking_number=sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'
            AND sdt.name='delivering_samples_to_district_hub'
            AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')")[0][:orders_delivered_at_dho]
        @dispatch_results_at_molecular = Speciman.find_by_sql("SELECT COUNT(*) AS dispatch_results_at_molecular FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            INNER JOIN specimen sp ON sp.tracking_number=sd.tracking_number
            WHERE sdt.name='delivering_results_to_facility'
            AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')")[0][:dispatch_results_at_molecular]
        @results_ready_at_molecular = Speciman.find_by_sql("SELECT COUNT(*) AS results_ready_at_molecular FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id 
            INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
            INNER JOIN tests t ON t.specimen_id = sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            INNER JOIN test_results tr ON tr.test_id = t.id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine' AND
            sdt.name = 'delivering_samples_to_molecular_lab' AND (tr.result <> '' OR tr.result IS NOT NULL)
            AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')")[0][:results_ready_at_molecular]
        @result_delivered_to_emr_electronically = 0
    end

    def total_orders
        if params[:site_name]
            site_name = params[:site_name]
            total_orders = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created, sp.id as id, 
                    tt.name AS test_type FROM specimen sp INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                    WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine' 
                    AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
                ")
            @data = {
                type: 'drillDown',
                orders: total_orders
            }
        else
            total_orders = Speciman.find_by_sql("SELECT sp.sending_facility AS facility,  COUNT(*) AS total_orders FROM specimen sp 
                    INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                    WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine' 
                        AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}') 
                    GROUP BY(sending_facility)
                ")
            @data = {
                type: 'topLevel',
                orders: total_orders
            }
        end
    end

    def uncollected_orders
        if params[:site_name]
            site_name = params[:site_name]
            uncollected_orders = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created,
                tt.name AS test_type FROM specimen sp
                INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'
                    AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}') AND sp.tracking_number NOT IN (SELECT tracking_number from specimen_dispatches)
            ")
            @data = {
                type: 'drillDown',
                orders: uncollected_orders
            }
        else
            uncollected_orders = Speciman.find_by_sql("SELECT sp.sending_facility AS facility, COUNT(*) AS uncollected_orders FROM specimen sp 
                    INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                    WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis')
                    AND sp.priority = 'Routine' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}') AND sp.tracking_number NOT IN (SELECT tracking_number from specimen_dispatches)
                    GROUP BY sp.sending_facility
                ")
            @data = {
                type: 'topLevel',
                orders: uncollected_orders
            }
        end
    end
    
    def orders_collected
        if params[:site_name]
            site_name = params[:site_name]
            orders_collected = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created,
                sd.date_dispatched, sp.id as id, 
                tt.name AS test_type FROM specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id 
                INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number 
                INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine' AND sdt.name = 'sample_dispatched_from_facility'
                    AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
            ")
            @data = {
                type: 'drillDown',
                orders: orders_collected
            }
        else
            orders_collected = Speciman.find_by_sql("SELECT sp.sending_facility AS facility, COUNT(*) AS orders_collected FROM specimen_dispatches sd 
                    INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
                    INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                    WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sdt.name = 'sample_dispatched_from_facility' 
                    AND sp.priority = 'Routine' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
                    GROUP BY sp.sending_facility
                ")
            @data = {
                type: 'topLevel',
                orders: orders_collected
            }
        end
    end
    
    def orders_delivered_at_dho
        if params[:site_name]
            site_name = params[:site_name]
            orders_delivered_at_dho = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created, 
                sp.id as id, tt.name AS test_type, sd.date_dispatched FROM specimen_dispatches sd 
                INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
                INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sdt.name = 'delivering_samples_to_district_hub'
                AND sp.priority = 'Routine' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
            ")
            @data = {
                type: 'drillDown',
                orders: orders_delivered_at_dho
            }
        else
            orders_delivered_at_dho = Speciman.find_by_sql("SELECT sp.district AS district, sp.sending_facility AS facility, COUNT(*) AS orders_delivered_at_dho FROM
                specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN
                specimen sp ON sp.tracking_number = sd.tracking_number INNER JOIN tests t ON t.specimen_id=sp.id 
                INNER JOIN test_types tt ON tt.id = t.test_type_id 
                WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sdt.name = 'delivering_samples_to_district_hub'
                    AND sp.priority = 'Routine' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
                GROUP BY(sp.sending_facility)
            ")
            @data = {
                type: 'topLevel',
                orders: orders_delivered_at_dho
            }
        end
    end

    def orders_delivered_at_molecular_lab
        if params[:site_name]
            site_name = params[:site_name]
            orders_delivered_at_molecular_lab = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, 
                sp.date_created, sp.id as id, tt.name AS test_type, sd.date_dispatched FROM specimen_dispatches sd 
                INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
                INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') 
                    AND sp.priority = 'Routine' AND sdt.name = 'delivering_samples_to_molecular_lab' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
            ")
            @data = {
                type: 'drillDown',
                orders: orders_delivered_at_molecular_lab
            }
        else
            orders_delivered_at_molecular_lab = Speciman.find_by_sql("SELECT sp.district AS district, sp.target_lab, sp.sending_facility AS facility, COUNT(*) AS orders_delivered_at_molecular_lab FROM
                specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN
                specimen sp ON sp.tracking_number = sd.tracking_number INNER JOIN tests t ON
                t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id WHERE
                (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sdt.name = 'delivering_samples_to_molecular_lab'
                    AND sp.priority = 'Routine' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
                GROUP BY(sp.sending_facility)
            ")
            @data = {
                type: 'topLevel',
                orders: orders_delivered_at_molecular_lab
            }
        end
    end

    def results_ready_at_molecular
        if params[:site_name]
            site_name = params[:site_name]
            results_ready_at_molecular = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created, sp.id as id,
                tt.name AS test_type, tr.time_entered FROM specimen_dispatches sd 
                INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id 
                INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
                INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id
                INNER JOIN test_results tr ON tr.test_id = t.id 
                WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') 
                    AND sp.priority = 'Routine'
                    AND sdt.name = 'delivering_samples_to_molecular_lab' AND (tr.result <> '' OR tr.result IS NOT NULL)
                    AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
            ")
            @data = {
                type: 'drillDown',
                orders: results_ready_at_molecular
            }
        else
            results_ready_at_molecular = Speciman.find_by_sql("SELECT sp.district AS district, sp.sending_facility AS facility, COUNT(*) AS results_ready_at_molecular FROM
            specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
            INNER JOIN tests t ON t.specimen_id = sp.id INNER JOIN test_results tr ON tr.test_id = t.id INNER JOIN test_types tt ON tt.id = t.test_type_id
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') 
            AND sp.priority = 'Routine'
            AND sdt.name = 'delivering_samples_to_molecular_lab' AND (tr.result <> '' OR tr.result IS NOT NULL) 
            AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
            GROUP BY(sp.sending_facility)
            ")
            @data = {
                type: 'topLevel',
                orders: results_ready_at_molecular
            }
        end
    end

    def dispatched_results_at_molecular
        if params[:site_name]
            site_name = params[:site_name]
            dispatched_results_at_molecular = Speciman.find_by_sql("SELECT sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created, sp.id as id,
                tt.name AS test_type,sd.date_dispatched FROM specimen_dispatches sd 
                INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id 
                INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
                INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
                WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') 
                    AND sdt.name = 'delivering_results_to_facility'
                    AND sp.priority = 'Routine' AND sp.sending_facility NOT IN ('#{$central_hospitals.join("','")}')
            ")
            @data = {
                type: 'drillDown',
                orders: dispatched_results_at_molecular
            }
        else
            dispatched_results_at_molecular = Speciman.find_by_sql("SELECT sp.district AS district, sp.sending_facility AS facility, COUNT(*) AS dispatched_results_at_molecular FROM
            specimen_dispatches sd INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id
             WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'
            AND sdt.name = 'delivering_results_to_facility' GROUP BY(sp.sending_facility)
            ")
            @data = {
                type: 'topLevel',
                orders: dispatched_results_at_molecular
            }
        end
    end
end
