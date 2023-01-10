module HomeDashboard
  module QueryBuilder
    module Orders 
      class << self
        def build(testtype: nil, start_date: nil, end_date: nil, facility_code: nil)
          sql = "SELECT count(DISTINCT sp.tracking_number) AS count, sp.specimen_status_id AS id FROM specimen sp"    
          sql = HomeDashboard::QueryBuilder::Sql.build(
            sql:sql, testtype: testtype, start_date: start_date, end_date: end_date, 
            facility_code: facility_code, inner_join_test: true
          )
          sql << " GROUP BY sp.specimen_status_id"
        end
      end
    end
  end
end