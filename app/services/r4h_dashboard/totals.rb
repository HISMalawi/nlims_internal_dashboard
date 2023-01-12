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
      end
  end
end