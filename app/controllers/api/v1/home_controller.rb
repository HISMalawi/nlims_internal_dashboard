class Api::V1::HomeController < ApplicationController
  before_action :set_params
  def index
    today = HomeDashboard::Utils::General.today
    obj = {
      cumulative: {
        orders: HomeDashboard::Orders.all(start_date: @params[:start_date], end_date: @params[:end_date], testtype: @params[:testtype], facility_code: @params[:facility_code]),
        tests: HomeDashboard::Tests.all(start_date: @params[:start_date], end_date: @params[:end_date], testtype: @params[:testtype], facility_code: @params[:facility_code])
      },
      today: {
        orders: HomeDashboard::Orders.all(start_date: today, end_date: today, testtype: @params[:testtype], facility_code: @params[:facility_code]),
        tests: HomeDashboard::Tests.all(start_date: today, end_date: today, testtype: @params[:testtype], facility_code: @params[:facility_code])
      },
      last_sync: HomeDashboard::Utils::LastSyncDate.get(@params[:facility_code]),
      test_types: HomeDashboard::Utils::TestTypes.all,
      sites: HomeDashboard::Utils::General.sites
    }
    render json: obj
  end

  private
    def set_params
      start_date = params['start_date'].nil? || params['start_date'].empty? ? nil : params['start_date']
      end_date = params['end_date'].nil? || params['end_date'].empty? ? nil : params['end_date']
      testtype = params['testtype'].nil? || params['testtype'].empty? ? nil : params['testtype']
      facility_code = params['facility_code'].nil? || params['facility_code'].empty? ? nil : params['facility_code']
      @params = {
        start_date: start_date,
        end_date: end_date,
        testtype: testtype,
        facility_code: facility_code
      }
    end
end