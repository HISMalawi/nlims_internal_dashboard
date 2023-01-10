require 'json'
module HomeDashboard
  module Utils
    module TestsJson 
      class << self
        TO_BE_STARTED_STATUS = [2,9]
        REJECTED_STATUS = 8
        STARTED_STATUS = 3
        VOIDED_FAILED_NOT_DONE_STATUS = [6,7,10]
        VERIFIED_STATUS = 5
        COMPLETED_STATUS = 4

        def build(tests)
          total = 0
          authorized = 0
          rejected = 0
          to_be_started = 0
          awaiting_results = 0
          voided_failed = 0
          unauthorized = 0
          parsed_tests = JSON.parse(tests.to_json)
          parsed_tests.each do | tests |
            total += tests['count']
            if tests['id'] == REJECTED_STATUS
              rejected += tests['count']
            elsif tests['id'] == VERIFIED_STATUS
              authorized += tests['count']
            elsif tests['id'] == COMPLETED_STATUS
              unauthorized += tests['count']
            elsif tests['id'] == STARTED_STATUS
              awaiting_results += tests['count']
            elsif TO_BE_STARTED_STATUS.include? tests['id']
              to_be_started += tests['count']
            elsif VOIDED_FAILED_NOT_DONE_STATUS.include? tests['id']
              voided_failed += tests['count']  
            end
          end
          obj = {
            total: total,
            authorized: authorized,
            rejected: rejected,
            unauthorized: unauthorized,
            awaiting_results: awaiting_results,
            to_be_started: to_be_started,
            voided_failed: voided_failed 
          }
          JSON.parse(obj.to_json)
        end
      end
    end
  end
end