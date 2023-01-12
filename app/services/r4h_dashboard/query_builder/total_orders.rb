module R4hDashboard 
  module QueryBuilder
    module TotalOrders
      class << self
        def total_count(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date, uncollected_orders: false)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sp.id AS id, COUNT(sp.id) AS count FROM specimen sp
              INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
              WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sp.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql << " AND sp.tracking_number NOT IN (SELECT tracking_number from specimen_dispatches)" if uncollected_orders
        end

        def total_count_per_site(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date, uncollected_orders: false)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT MAX(sp.id) AS id, sp.sending_facility,  COUNT(*) AS count FROM specimen sp
              INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
              WHERE (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sp.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql << " AND sp.tracking_number NOT IN (SELECT tracking_number from specimen_dispatches)" if uncollected_orders
          sql << " GROUP BY(sending_facility)"
        end

        def drilldown(site_name: '', start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date, uncollected_orders: false)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sp.id AS id, sp.tracking_number, sp.sending_facility AS facility ,sp.district, sp.date_created,
              tt.name AS test_type FROM specimen sp
              INNER JOIN tests t ON t.specimen_id=sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id 
              WHERE sp.sending_facility='#{site_name}' AND (tt.name='Viral Load' OR tt.name='Early Infant Diagnosis') AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(sp.created_at,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql << " AND sp.tracking_number NOT IN (SELECT tracking_number from specimen_dispatches)" if uncollected_orders
        end
      end
    end
  end
end