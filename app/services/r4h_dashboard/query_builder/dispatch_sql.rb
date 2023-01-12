module R4hDashboard 
  module QueryBuilder
    module DispatchSql
      class << self
        def total_count(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sdt.id AS id, sdt.name, COUNT(sdt.id) as count FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            INNER JOIN specimen sp ON sp.tracking_number=sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sd.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql <<" GROUP BY sdt.id"
        end

        def total_count_per_site(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date, dispatch_type_id: 4)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sdt.id AS id,sdt.name, sp.sending_facility, MAX(sp.district) AS district, MAX(sd.delivery_location) AS delivery_location, COUNT(sdt.id) AS count FROM specimen_dispatches sd 
              INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
              INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
              WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sdt.id = #{dispatch_type_id} 
              AND sp.priority = 'Routine'"
          sql = " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sd.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql <<" GROUP BY sdt.id, sp.sending_facility"
        end

        def drilldown(site_name: '', start_date: R4hDashboard::Utils::General.start_date, 
          end_date: R4hDashboard::Utils::General.end_date, dispatch_type_id: 2)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sp.id as id, sp.tracking_number, sp.sending_facility, sp.district, sp.date_created, tt.name AS test_type,
            sd.date_dispatched, sd.delivery_location, TimestampDiff(HOUR, sp.date_created, sd.date_dispatched) AS tat_when_ordered_to_dispatched 
            FROM specimen_dispatches sd 
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') 
            AND sp.priority = 'Routine' AND sdt.id = #{dispatch_type_id}"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sd.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
        end
      end
    end
  end
end