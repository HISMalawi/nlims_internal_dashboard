module R4hDashboard 
  module QueryBuilder
    module ResultReadyAtMolecular
      class << self
        def build(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT COUNT(t.id) AS count, sdt.id AS id FROM specimen_dispatches sd
            INNER JOIN specimen_dispatch_types sdt ON sdt.id = sd.dispatcher_type_id 
            INNER JOIN specimen sp ON sp.tracking_number = sd.tracking_number
            INNER JOIN tests t ON t.specimen_id = sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
            INNER JOIN test_results tr ON tr.test_id = t.id 
            WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine' AND
            sdt.id = 1 AND (tr.result <> '' OR tr.result IS NOT NULL)"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sd.date_dispatched,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
        end
      end
    end
  end
end