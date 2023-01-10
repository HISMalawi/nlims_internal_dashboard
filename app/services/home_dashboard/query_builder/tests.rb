module HomeDashboard
  module QueryBuilder
    module Tests 
      class << self
        def build(testtype: nil, start_date: nil, end_date: nil, facility_code: nil)
          sql = "SELECT count(DISTINCT t.id) AS count, t.test_status_id AS id FROM specimen sp
          INNER JOIN tests t ON t.specimen_id=sp.id"    
          sql = HomeDashboard::QueryBuilder::Sql.build(
            sql:sql, testtype: testtype, start_date: start_date, end_date: end_date, 
            facility_code: facility_code
          )
          sql << " GROUP BY t.test_status_id"
        end
      end
    end
  end
end