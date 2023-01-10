require 'json'
module HomeDashboard
  module Utils
    module TestTypes
      class << self
        def all
          test_types = Speciman.find_by_sql("SELECT id,name FROM test_types")
          JSON.parse(filter(test_types).to_json)
        end

        def filter(test_types)
          test_types_to_remove = ['cd4 count', 'corona virus']
          test_types.each do |test_type|
            if test_types_to_remove.include?(test_type[:name].downcase)
              test_types.delete(test_type)
            end
          end
          return test_types
        end
      end
    end
  end
end