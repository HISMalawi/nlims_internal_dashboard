require 'date'
module HomeDashboard
  module QueryBuilder
    module Sql
      class << self
        def build(sql: '', testtype: nil, start_date: nil, end_date: nil, facility_code: nil, inner_join_test: false)
          end_date = Date.today.strftime('%Y-%m-%d') if end_date.nil?
          if !testtype.nil?
            sql << " INNER JOIN tests t ON t.specimen_id=sp.id" if inner_join_test
            testtype_sql = " INNER JOIN test_types tt ON tt.id=t.test_type_id WHERE tt.name = '#{testtype.gsub('Aand','&')}'"
            sql << testtype_sql
            sql << " AND (substr(sp.date_created,1,10) BETWEEN '#{start_date}' AND '#{end_date}')" if !start_date.nil?
            sql << " AND " << generate_facility_code_condition(facility_code) if !facility_code.nil?
          else
            if !start_date.nil?
              sql << " WHERE (substr(sp.date_created,1,10) BETWEEN '#{start_date}' AND '#{end_date}')"
              sql << " AND " << generate_facility_code_condition(facility_code) if !facility_code.nil?
            end
          end
          if testtype.nil? && start_date.nil? && !facility_code.nil?
            sql << " WHERE " << generate_facility_code_condition(facility_code)
          end
          return sql
        end

        def generate_facility_code_condition(facility_code)
          init_facility_code_length = facility_code.length
          final_facility_code_length = init_facility_code_length + 1
          if init_facility_code_length == 2
              sql_condition =  "(substr(sp.tracking_number,1,#{final_facility_code_length})='X#{lab}' AND substr(sp.tracking_number,1,4)!='XNDH')"
          elsif init_facility_code_length == 3
              if (facility_code != 'TDH' or facility_code != 'NMT')
                  sql_condition = "substr(sp.tracking_number,1,#{final_facility_code_length})='X#{facility_code}'" 
              end
              if facility_code == 'TDH'
                  sql_condition = "(substr(sp.tracking_number,1,#{final_facility_code_length})='X#{facility_code}' OR substr(sp.tracking_number,1,3)='XTO')"
              end
              if facility_code == 'NMT'
                sql_condition = "(substr(sp.tracking_number,1,#{final_facility_code_length})='X#{facility_code}' AND substr(sp.tracking_number,1,#{final_facility_code_length+1})!='XNMTH')" 
              end
          else
              sql_condition = "substr(sp.tracking_number,1,#{final_facility_code_length})='X#{facility_code}'" 
          end
          return sql_condition
        end
      end
    end
  end
end