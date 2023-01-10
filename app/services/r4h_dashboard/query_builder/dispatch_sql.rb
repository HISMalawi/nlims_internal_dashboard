module R4hDashboard 
  module QueryBuilder
    module DispatchSql
      class << self
        def build(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sdt.id AS id, sdt.name, COUNT(sd.id) as count FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id
            INNER JOIN specimen sp ON sp.tracking_number=sd.tracking_number
            INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'"
          sending_facility_condition = " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << sending_facility_condition
          sql << " AND (substr(sd.date_dispatched,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql <<" GROUP BY sdt.id"
        end
      end
    end
  end
end