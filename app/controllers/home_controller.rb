require 'date'

class HomeController < ApplicationController
    def index
        @labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
    end

    def query_lab_stats_total_orders
        lab  = params[:lab_name]
        period = params[:period]
        month = period.split('-')[1]
        puts month
        puts period
        data = "0"
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end


    def ping_site
        lab = params[:lab]
        
    end

    def query_lab_stats_total_orders_accepted
        lab  = params[:lab_name]
        period = params[:period].to_s
        puts period
        puts period
        
        data = "0"
            
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2")
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
    def query_lab_stats_total_orders_rejected
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
            
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen where substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end

    def query_lab_stats_total_tests
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end

    def query_lab_stats_total_tests_verrified
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end
    


    def query_lab_stats_total_tests_with_results
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=4 OR tests.test_status_id=5) AND substr(tests.time_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 OR tests.test_status_id=5")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end

    def query_lab_stats_total_tests_waiting_results
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=7 AND substr(tests.time_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=7")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end

    def query_lab_stats_total_tests_rejected
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end
    
    def query_lab_stats_total_tests_to_be_started
        lab  = params[:lab_name]
        period = params[:period]
        data = "0"
        
        if period != "false"
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=9 AND substr(tests.time_created,1,10)='#{period}'")
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            res = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=9")
            if !res.blank?
                data = res[0]['total_count']
            end
        end

        render plain: data and return
    end
end
