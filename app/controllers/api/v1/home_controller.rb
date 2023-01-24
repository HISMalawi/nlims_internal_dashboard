class Api::V1::HomeController < ApplicationController
  before_action :set_params
  def orders
    today = HomeDashboard::Utils::General.today
    obj = {
      cumulative: HomeDashboard::Orders.all(start_date: @params[:start_date], end_date: @params[:end_date], testtype: @params[:testtype], facility_code: @params[:facility_code]),
      today: HomeDashboard::Orders.all(start_date: today, end_date: today, testtype: @params[:testtype], facility_code: @params[:facility_code])

    }
    render json: obj
  end

  def tests
    today = HomeDashboard::Utils::General.today
    obj = {
      cumulative: HomeDashboard::Tests.all(start_date: @params[:start_date], end_date: @params[:end_date], testtype: @params[:testtype], facility_code: @params[:facility_code]),
      today: HomeDashboard::Tests.all(start_date: today, end_date: today, testtype: @params[:testtype], facility_code: @params[:facility_code])
    }
    render json: obj
  end 

  def sites 
    obj = {
      sites: HomeDashboard::Utils::General.sites
    }
    render json: obj
  end

  def test_types
    obj = {
      test_types: HomeDashboard::Utils::TestTypes.all
    }
    render json: obj
  end

  def last_sync_date
    obj = {
      last_sync_date: HomeDashboard::Utils::LastSyncDate.get(@params[:facility_code])
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