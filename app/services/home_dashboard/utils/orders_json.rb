require 'json'
module HomeDashboard
  module Utils
    module OrdersJson 
      class << self
        ACCEPTED_STATUS = 2
        REJECTED_STATUS = 3
        def build(orders)
          submitted = 0
          accepted = 0
          rejected = 0
          to_be_accepted = 0
          parsed_orders = JSON.parse(orders.to_json)
          parsed_orders.each do | order |
            submitted += order['count']
            if order['id'] == ACCEPTED_STATUS
              accepted += order['count']
            elsif order['id'] == REJECTED_STATUS
              rejected += order['count']
            else
              to_be_accepted += order['count']
            end
          end
          obj = {
            submitted: submitted,
            accepted: accepted,
            rejected: rejected,
            to_be_accepted: to_be_accepted
          }
          JSON.parse(obj.to_json)
        end
      end
    end
  end
end