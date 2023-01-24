module HomeDashboard
  module Utils
    module LastSyncDate 
      class << self
        def get(facility_code)
         if facility_code.nil?
          sync_date = 'N/A'
         else
          facility_code_condition = HomeDashboard::QueryBuilder::Sql.generate_facility_code_condition(facility_code)
          sql = "SELECT sp.created_at FROM specimen sp WHERE " << facility_code_condition
          sql << " ORDER BY id DESC LIMIT 1"
          last_specimen_created = Speciman.find_by_sql(sql)
          if !last_specimen_created.blank?
            sync_date = last_specimen_created[0][:created_at]
          else
            sync_date = 'N/A'
          end
         end
        end
      end
    end
  end
end