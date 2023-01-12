require 'json'
module R4hDashboard
  module Utils
    module Totals
      class << self 
       def build(acknowledgement, total_orders, dispatches, result_ready)
        dispatches.each do | dispatch |
          if 'sample_dispatched_from_facility'.eql? dispatch['name']
            uncollected_orders = total_orders[0]['count'] - dispatch['count']
            total_orders.concat(
              [{
                'id' => total_orders[0]['id']+1,
                'name' => 'uncollected_orders',
                'count' => uncollected_orders
              }]
            )
          end
        end
        obj = {
          emr_acknowledged: acknowledgement,
          total_orders: total_orders,
          total_dispatches: dispatches,
          results_ready_at_molecular: result_ready
        }
        JSON.parse(obj.to_json)
       end

       def acknowledgement(**kwargs)
        acknowledgemet_sql = R4hDashboard::QueryBuilder::AcknowledgeResult.total_count(**kwargs)
        JSON.parse(Speciman.find_by_sql(acknowledgemet_sql).to_json)
       end

       def dispatch(**kwargs)
        dispatch_sql = R4hDashboard::QueryBuilder::DispatchSql.total_count(**kwargs)
        JSON.parse(Speciman.find_by_sql(dispatch_sql).to_json)
       end

       def total_orders(**kwargs)
        orders_sql = R4hDashboard::QueryBuilder::TotalOrders.total_count(**kwargs)
        JSON.parse(Speciman.find_by_sql(orders_sql).to_json)
       end

       def results_ready_at_molecular(**kwargs)
        result_ready_sql = R4hDashboard::QueryBuilder::ResultReadyAtMolecular.total_count(**kwargs)
        JSON.parse(Speciman.find_by_sql(result_ready_sql).to_json)
       end
      end 
    end
  end
end