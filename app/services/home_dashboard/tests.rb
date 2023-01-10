module HomeDashboard
  module Tests
    class << self
      def all(**kwargs)
        sql = HomeDashboard::QueryBuilder::Tests.build(**kwargs)
        tests = Speciman.find_by_sql(sql)
        HomeDashboard::Utils::TestsJson.build(tests)
      end 
    end
  end
end