module R4hDashboard
  module ResultReadyMolecular
    class << self
      def count_per_site(**kwargs)
        sql = R4hDashboard::QueryBuilder::ResultReadyAtMolecular.total_count_per_site(**kwargs)
        JSON.parse(Speciman.find_by_sql(sql).to_json)
      end

      def drilldown(**kwargs)
        sql = R4hDashboard::QueryBuilder::ResultReadyAtMolecular.drilldown(**kwargs)
        JSON.parse(Speciman.find_by_sql(sql).to_json)
      end
    end
  end
end