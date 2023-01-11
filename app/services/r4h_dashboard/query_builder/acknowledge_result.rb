module R4hDashboard 
  module QueryBuilder
    module AcknowledgeResult
      class << self 
        def count_all(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT t.test_result_receipent_types as id, trrt.name, COUNT(t.test_result_receipent_types) AS count FROM specimen sp 
            INNER JOIN tests t ON t.specimen_id = sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id
            INNER JOIN test_result_recepient_types trrt ON trrt.id = t.test_result_receipent_types
            INNER JOIN test_results tr ON tr.test_id = t.id WHERE (tt.name = 'Viral Load' OR tt.name = 'Early Infant Diagnosis')
            AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(t.time_created,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql << " GROUP BY t.test_result_receipent_types"
        end

        def count_per_site(start_date: R4hDashboard::Utils::General.start_date, end_date: R4hDashboard::Utils::General.end_date)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT t.test_result_receipent_types as id, trrt.name, sp.sending_facility, sp.district,
            COUNT(t.test_result_receipent_types) AS count
            FROM specimen sp INNER JOIN tests t ON t.specimen_id = sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id
            INNER JOIN test_result_recepient_types trrt ON trrt.id = t.test_result_receipent_types
            INNER JOIN test_results tr ON tr.test_id = t.id WHERE (tt.name = 'Viral Load' OR tt.name = 'Early Infant Diagnosis')
            AND sp.priority = 'Routine'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(t.time_created,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
          sql << " GROUP BY t.test_result_receipent_types,sp.sending_facility, sp.district"
        end

        def drill_details(site_name: '', start_date: R4hDashboard::Utils::General.start_date, 
          end_date: R4hDashboard::Utils::General.end_date, acknowledgement_type: 2)
          central_hospitals = R4hDashboard::Utils::General.central_hospitals
          sql = "SELECT sp.id AS id, sp.tracking_number,t.test_result_receipent_types AS acknoledgemet_type, sp.sending_facility AS facility,
                 sp.district,  sp.date_created, tt.name AS test_type, t.date_result_given AS emrack_date 
                 FROM specimen sp INNER JOIN tests t ON t.specimen_id = sp.id INNER JOIN test_types tt ON tt.id = t.test_type_id
                INNER JOIN test_results tr ON tr.test_id = t.id WHERE (tt.name = 'Viral Load' OR tt.name = 'Early Infant Diagnosis')
                AND sp.priority = 'Routine' AND t.test_result_receipent_types = #{acknowledgement_type}  AND sp.sending_facility='#{site_name}'"
          sql << " AND sp.sending_facility NOT IN #{central_hospitals}"
          sql << " AND (substr(t.time_created,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
        end
      end
    end
  end
end