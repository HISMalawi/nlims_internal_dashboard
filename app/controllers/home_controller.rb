require 'date'
require 'json'
require 'test_data_querying'

class HomeController < ApplicationController
    include TestDataQuerying
    def index
        @labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
        @genexpert_labs = YAML.load_file "#{Rails.root}/public/genexpert_labs.json"
       
    end

    def get_viral_data
        info = []
        lab_name = params[:lab_name].split("-")[1]
        lab_code = params[:lab_name].split("-")[0]
        if lab_name.include?("Laboratory")
            last_name = lab_name.gsub("Laboratory","")
            rs = Speciman.find_by_sql("SELECT tests.id AS test_id, specimen.id AS sp_id, test_statuses.name AS test_status, specimen.tracking_number, specimen.date_created, specimen.sending_facility FROM specimen
                                INNER JOIN tests ON tests.specimen_id = specimen.id
                                INNER JOIN test_statuses ON test_statuses.id = tests.test_status_id
                                WHERE tests.test_type_id = 71 AND (specimen.target_lab ='#{lab_name}' OR  specimen.target_lab ='#{last_name}'
                                OR substring(specimen.tracking_number,2,'#{lab_code.length}')='#{lab_code}') order by specimen.id DESC
                            ")
        else
            rs = Speciman.find_by_sql("SELECT tests.id AS test_id, specimen.id AS sp_id, test_statuses.name AS test_status, specimen.tracking_number, specimen.date_created, specimen.sending_facility FROM specimen
                INNER JOIN tests ON tests.specimen_id = specimen.id
                INNER JOIN test_statuses ON test_statuses.id = tests.test_status_id
                WHERE tests.test_type_id = 71 AND (specimen.sending_facility ='#{lab_name}' 
                OR substring(specimen.tracking_number,2,'#{lab_code.length}') ='#{lab_code}') order by specimen.id DESC
            ")
        end

        if !rs.blank?
            rs.each do |data| 
                sp_id = data['sp_id']
                test_status = data['test_status'] 
                tracking_number = data['tracking_number']
                date_created = data['date_created'].to_date
                sending_facility = data['sending_facility'] 
                test_id = data['test_id']
                accepted_time = {
                    time_updated: 'N/A',
                    specimen_status: 'N/A'
                }
                results = {
                    date_result_available: 'N/A',
                    result: 'N/A'
                }
                specimen_status = Speciman.find_by_sql("SELECT specimen_status_trails.time_updated, specimen_statuses.name AS status
                                                    FROM specimen_status_trails
                                                    INNER JOIN specimen_statuses 
                                                    ON specimen_statuses.id = specimen_status_trails.specimen_status_id
                                                    WHERE specimen_status_trails.specimen_id ='#{sp_id}' group by specimen_status_trails.id asc limit 1")
                if !specimen_status.blank?
                    accepted_time["time_updated"] = specimen_status[0]['time_updated'].to_date if !specimen_status[0]['time_updated'].blank?
                    accepted_time["specimen_status"] = specimen_status[0]['status']
                end 

                test_results = Speciman.find_by_sql("SELECT DISTINCT test_results.time_entered, test_results.result
                                            FROM test_results WHERE test_results.test_id = #{test_id}            
                    ")
                if !test_results.blank?
                    results['date_result_available'] = test_results[0]['time_entered'].to_date if !test_results[0]['time_entered'].blank?
                    results['result'] = test_results[0]['result']
                end

                info_ = { 
                    "tracking_number": tracking_number,
                    "test_status": test_status,
                    "date_created": date_created,
                    "sending_facility": sending_facility,
                    "specimen_status": accepted_time,
                    "test_results": results
                 }
                 info.push(info_)
            end
        end

        render plain: JSON.generate(info)
        
    end

    def all
        period = Date.today
        labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
        genexpert_labs = YAML.load_file "#{Rails.root}/public/genexpert_labs.json"
        @sites = labs.merge(genexpert_labs)
        @period =period
        
        render template:"home/all_labs"
    end
    
    def query_lab_stats_all_labs
        period = Date.today
        total_orders = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen")[0]['total_count']
        total_orders_accepted = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE specimen_status_id=2")[0]['total_count']
        total_orders_to_be_accepted = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE specimen_status_id=1")[0]['total_count']
        total_orders_rejected = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE specimen_status_id=3")[0]['total_count']
        total_tests = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id")[0]['total_count']
        total_tests_verrified = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=5")[0]['total_count']
        total_tests_with_results = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=4")[0]['total_count']
        total_tests_waiting_results = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=3")[0]['total_count']
        total_tests_to_be_started = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE  (tests.test_status_id=2 OR tests.test_status_id=9)")[0]['total_count']
        total_tests_rejected = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=8")[0]['total_count']
        total_tests_voided = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)")[0]['total_count']
        
        total_orders_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE substr(date_created,1,10)='#{period}'")[0]['total_count']
        total_orders_accepted_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE specimen_status_id=2 AND substr(date_created,1,10)='#{period}'")[0]['total_count']
        total_orders_to_be_accepted_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE specimen_status_id=1 AND substr(date_created,1,10)='#{period}'")[0]['total_count']
        total_orders_rejected_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen WHERE specimen_status_id=3 AND substr(date_created,1,10)='#{period}'")[0]['total_count']
        
        total_tests_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        total_tests_verrified_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        total_tests_with_results_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        total_tests_waiting_results_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        total_tests_to_be_started_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE  (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        total_tests_rejected_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        total_tests_voided_today = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id WHERE (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7) AND substr(tests.time_created,1,10)='#{period}'")[0]['total_count']
        
        data = {
            total_orders_submitted: total_orders,
            total_orders_accepted: total_orders_accepted,
            total_orders_to_be_accepted: total_orders_to_be_accepted,
            total_orders_rejected: total_orders_rejected,
            total_tests: total_tests,
            total_tests_verrified: total_tests_verrified,
            total_tests_with_results: total_tests_with_results,
            total_tests_waiting_results: total_tests_waiting_results,
            total_tests_to_be_started: total_tests_to_be_started,
            total_tests_rejected: total_tests_rejected,
            total_tests_voided_failed: total_tests_voided,
            total_orders_submitted_today: total_orders_today,
            total_orders_accepted_today: total_orders_accepted_today,
            total_orders_to_be_accepted_today: total_orders_to_be_accepted_today,
            total_orders_rejected_today: total_orders_rejected_today,
            total_tests_today: total_tests_today,
            total_tests_verrified_today: total_tests_verrified_today,
            total_tests_with_results_today: total_tests_with_results_today,
            total_tests_waiting_results_today: total_tests_waiting_results_today,
            total_tests_to_be_started_today: total_tests_to_be_started_today,
            total_tests_rejected_today: total_tests_rejected_today,
            total_tests_voided_failed_today: total_tests_voided_today
        }   
        render plain: JSON.generate(data) and return
    end

    def query_lab_stats_total_orders
        sql_query = tests_orders_sql_query(params,status="",queried_in="orders")
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

    def query_lab_stats_total_orders_accepted
        status = "AND specimen_status_id=2"
        sql_query = tests_orders_sql_query(params,status=status,queried_in="orders")
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

    def query_lab_stats_total_orders_to_be_accepted
        status = "AND (specimen_status_id=1 OR specimen_status_id=4)"
        sql_query = tests_orders_sql_query(params,status=status,queried_in="orders")
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

    def query_lab_stats_total_orders_rejected
        status = "AND specimen_status_id=3"
        sql_query = tests_orders_sql_query(params,status=status,queried_in="orders")
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

    def query_lab_stats_total_tests
        sql_query = tests_orders_sql_query(params,status="")
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

        #  authorized
    def query_lab_stats_total_tests_verrified
        status = "AND tests.test_status_id=5"
        sql_query = tests_orders_sql_query(params,status=status)
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end
    
    # unauthorized
    def query_lab_stats_total_tests_with_results
        status = "AND tests.test_status_id=4"
        sql_query = tests_orders_sql_query(params,status=status)
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

    def query_lab_stats_total_tests_waiting_results
        status = "AND tests.test_status_id=3"
        sql_query = tests_orders_sql_query(params,status=status)
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end



    def query_lab_stats_total_tests_rejected
        status = "AND tests.test_status_id=8"
        sql_query = tests_orders_sql_query(params,status=status)
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end
    


    def query_lab_stats_total_tests_to_be_started
        status = "AND (tests.test_status_id=2 OR tests.test_status_id=9)"
        sql_query = tests_orders_sql_query(params,status=status)
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end




    def query_lab_stats_total_tests_voided_failed
        status = "AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)"
        sql_query = tests_orders_sql_query(params,status=status)
        res_today = Speciman.find_by_sql(sql_query[:query_for_today_data])[0]['total_count']
        res_periodic = Speciman.find_by_sql(sql_query[:query_for_periodic_data])[0]['total_count']
        render plain: JSON.generate({data: res_periodic, today: res_today}) and return
    end

    def query_last_sync 
        lab  = params[:lab_name]
        date_synced = TestDataQuerying.last_sync_date(lab)
        render plain: JSON.generate({data: date_synced, lab: lab}) and return
    end

    def get_tests
        test_types = TestType.find_by_sql("SELECT name FROM test_types")
        tests = []
        for test_type in test_types
            tests.push(test_type.name) 
        end
        render plain: tests and return    # render plain: JSON.generate({data: data}) and return
    end

    
end

