class Api::V1::R4hController < ApplicationController
  before_action :set_params

  def index
    start_date = @params[:start_date]
    end_date = @params[:end_date]
    render json: R4hDashboard::Totals.get(start_date: start_date, end_date: end_date)
  end

  def count_per_site
    start_date = @params[:start_date]
    end_date = @params[:end_date]
    url_level = @params[:url_level]
    if url_level == 'dispatches'
      dispatch_type_id = @params[:dispatch_type_id]
      obj = {
        url_level: url_level,
        data: R4hDashboard::Dispatch::count_per_site(start_date: start_date, end_date: end_date, dispatch_type_id: dispatch_type_id)
      }
    elsif url_level == 'acknowledgement'
      acknowledgement_type = @params[:acknowledgement_type]
      obj = {
        url_level: url_level,
        data: R4hDashboard::Acknowledgement.count_per_site(start_date: start_date, end_date: end_date, acknowledgement_type: acknowledgement_type)
      }
    elsif url_level == 'result_ready'
      obj = {
        url_level: url_level,
        data: R4hDashboard::ResultReadyMolecular.count_per_site(start_date: start_date, end_date: end_date)
      }
    elsif url_level == 'total'
      uncollected_orders = @params[:uncollected_orders]
      obj = {
        url_level: url_level,
        data: R4hDashboard::Totals.count_per_site(start_date: start_date, end_date: end_date, uncollected_orders: uncollected_orders)
      }
    else
      obj = {}
    end
    render json: obj
  end

  def drilldown
    start_date = @params[:start_date]
    end_date = @params[:end_date]
    url_level = @params[:url_level]
    site_name = @params[:site_name]
    if url_level == 'dispatches'
      dispatch_type_id = @params[:dispatch_type_id]
      obj = {
        url_level: url_level,
        data: R4hDashboard::Dispatch::drilldown(site_name: site_name, start_date: start_date, end_date: end_date, dispatch_type_id: dispatch_type_id)
      }
    elsif url_level == 'acknowledgement'
      acknowledgement_type = @params[:acknowledgement_type]
      obj = {
        url_level: url_level,
        data: R4hDashboard::Acknowledgement.drilldown(site_name: site_name, start_date: start_date, end_date: end_date, acknowledgement_type: acknowledgement_type)
      }
    elsif url_level == 'result_ready'
      obj = {
        url_level: url_level,
        data: R4hDashboard::ResultReadyMolecular.drilldown(site_name: site_name, start_date: start_date, end_date: end_date)
      }
    elsif url_level == 'total'
      uncollected_orders = @params[:uncollected_orders]
      obj = {
        url_level: url_level,
        data: R4hDashboard::Totals.drilldown(site_name: site_name, start_date: start_date, end_date: end_date, uncollected_orders: uncollected_orders)
      }
    else
      obj = {}
    end
    render json: obj
  end

  private
    def set_params
      start_date = params['start_date'].empty? ? R4hDashboard::Utils::General.start_date : Date.parse(params['start_date']).strftime("%Y-%m-%d") if !params['start_date'].nil?
      end_date = params['end_date'].empty? ? R4hDashboard::Utils::General.end_date : Date.parse(params['end_date']).strftime("%Y-%m-%d") if !params['end_date'].nil?
      acknowledgement_type = params['acknowledgement_type'].empty? ? 2 : params['acknowledgement_type'] if !params['acknowledgement_type'].nil?
      dispatch_type_id = params['dispatch_type_id'].empty? ? 4 : params['dispatch_type_id'] if !params['dispatch_type_id'].nil?
      site_name = params['site_name'].empty? ? '' : params['site_name'] if !params['site_name'].nil?
      uncollected_orders = params['uncollected_orders'].empty? ? false : params['uncollected_orders'] if !params['uncollected_orders'].nil?
      url_level = params['url_level']
      @params = {
        start_date: start_date.nil? ? R4hDashboard::Utils::General.start_date : start_date,
        end_date: end_date.nil? ? R4hDashboard::Utils::General.end_date : end_date,
        acknowledgement_type: acknowledgement_type.nil? ? 2 : acknowledgement_type,
        dispatch_type_id: dispatch_type_id.nil? ? 4 : dispatch_type_id,
        site_name: site_name.nil? ? '' : site_name,
        uncollected_orders: uncollected_orders.nil? ? false : uncollected_orders,
        url_level: url_level.nil? ? false : url_level
      }
    end

end
