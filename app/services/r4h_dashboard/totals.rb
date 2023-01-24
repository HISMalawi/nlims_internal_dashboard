module R4hDashboard
  module Totals
      class << self
        def get(**kwargs)
          acknowledgement = R4hDashboard::Utils::Totals.acknowledgement(**kwargs)
          dispatch = R4hDashboard::Utils::Totals.dispatch(**kwargs)
          total_orders = R4hDashboard::Utils::Totals.total_orders(**kwargs)
          results_ready_at_molecular = R4hDashboard::Utils::Totals.results_ready_at_molecular(**kwargs)
          R4hDashboard::Utils::Totals.build(acknowledgement,total_orders, dispatch, results_ready_at_molecular)
        end

        def count_per_site(**kwargs)
          sql = R4hDashboard::QueryBuilder::TotalOrders.total_count_per_site(**kwargs)
          JSON.parse(Speciman.find_by_sql(sql).to_json)
        end
  
        def drilldown(**kwargs)
          sql = R4hDashboard::QueryBuilder::TotalOrders.drilldown(**kwargs)
          JSON.parse(Speciman.find_by_sql(sql).to_json)
        end
      end
  end
end