module R4hDashboard 
  module QueryBuilder
    module TotalOrders
      class << self
        def build(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT COUNT(sp.id) AS count FROM specimen sp
              INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
              WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sp.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
        end
      end
    end
  end
end