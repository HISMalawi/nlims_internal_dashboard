require 'date'

class HomeController < ApplicationController
    def index
        @labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
    end

    def query_lab_stats_total_orders
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
        
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end

    def query_last_sync
        lab  = params[:lab_name]      
        data = "0"
        res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,4)='X#{lab}' ORDER BY id DESC LIMIT 1")
        if !res.blank?
           data = res[0]['created_at']
        end
        render plain: data and return
    end

    def qech
        year = params[:year]
        month = params[:month]
        month_year = Date::MONTHNAMES[month.to_i] + ", "+ year.to_s
        data = {
            total_orders_submitted:350, total_orders_accepted: 300,
            total_orders_rejected: 50, total_tests: 1000,
            total_tests_verrified: 800, total_tests_with_results:700,
            total_tests_rejected: 100, total_tests_waiting_results: 50,
            total_tests_to_be_started: 70, timeline: month_year,
            sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
        }
        render json: data
    end

    def kch
        year = params[:year]
        month = params[:month]
        month_year = Date::MONTHNAMES[month.to_i] + ", "+ year.to_s
        data = {
            total_orders_submitted:33350, total_orders_accepted: 33300,
            total_orders_rejected: 3350, total_tests: 331000,
            total_tests_verrified: 33800, total_tests_with_results:33700,
            total_tests_rejected: 33100, total_tests_waiting_results: 3350,
            total_tests_to_be_started: 3370, timeline: month_year,
            sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
        }
        render json: data
    end

    def mzuzuch
        year = params[:year]
        month = params[:month]
        month_year = Date::MONTHNAMES[month.to_i] + ", "+ year.to_s
        data = {
            total_orders_submitted:11350, total_orders_accepted: 11300,
            total_orders_rejected: 1150, total_tests: 111000,
            total_tests_verrified: 11800, total_tests_with_results:11700,
            total_tests_rejected: 11100, total_tests_waiting_results: 1150,
            total_tests_to_be_started: 1170, timeline: month_year,
            sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
        }
        render json: data
    end

    def mzimbadh
        year = params[:year]
        month = params[:month]
        month_year = Date::MONTHNAMES[month.to_i] + ", "+ year.to_s
        data = {
            total_orders_submitted:88350, total_orders_accepted: 88300,
            total_orders_rejected: 8850, total_tests: 881000,
            total_tests_verrified: 88800, total_tests_with_results:88700,
            total_tests_rejected: 88100, total_tests_waiting_results: 8850,
            total_tests_to_be_started: 8870, timeline: month_year,
            sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
        }
        render json: data
    end


    def genexpert
        year = params[:year]
        month = params[:month]
        month_year = Date::MONTHNAMES[month.to_i] + ", "+ year.to_s
        if params[:hospital] == 'ekwendeni'
        data = {
            total_orders_submitted:22350, total_orders_accepted: 22300,
            total_orders_rejected: 2250, total_tests: 221000,
            total_tests_verrified: 22800, total_tests_with_results:22700,
            total_tests_rejected: 22100, total_tests_waiting_results: 2250,
            total_tests_to_be_started: 2270, timeline: month_year,
            sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
        }
        render json: data

        elsif
            params[:hospital] == 'ekwandeni'
            data = {
                total_orders_submitted:1111350, total_orders_accepted: 1111300,
                total_orders_rejected: 111150, total_tests: 11111000,
                total_tests_verrified: 1111800, total_tests_with_results:1111700,
                total_tests_rejected: 1111100, total_tests_waiting_results: 111150,
                total_tests_to_be_started: 111170, timeline: month_year,
                sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
            }
            render json: data
        elsif
            params[:hospital] == 'chiwevi'
            data = {
                total_orders_submitted:1100350, total_orders_accepted: 1001300,
                total_orders_rejected: 100150, total_tests: 10011000,
                total_tests_verrified: 1001800, total_tests_with_results:1001700,
                total_tests_rejected: 1001100, total_tests_waiting_results: 100150,
                total_tests_to_be_started: 100170, timeline: month_year,
                sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
            }
            render json: data
        else
            render json: {resp: 'Not found'}
        end
    end
end
