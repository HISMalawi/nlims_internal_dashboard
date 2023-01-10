module HomeDashboard
  module Orders
    class << self
      def all(**kwargs)
        sql = HomeDashboard::QueryBuilder::Orders.build(**kwargs)
        orders = Speciman.find_by_sql(sql)
        HomeDashboard::Utils::OrdersJson.build(orders)
      end 
    end
  end
end