require 'date'
require 'json'

class HomeController < ApplicationController
    def index
        @labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
        @genexpert_labs = YAML.load_file "#{Rails.root}/public/genexpert_labs.json"
       
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
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
        if period != "false"
            if test_type.blank?
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{period}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{date}'
                    ") 
                elsif lab.length == 3
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{period}'
                        ")
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{period}'
                        ") 
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(date_created,1,10)='#{period}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(date_created,1,10)='#{date}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND substr(date_created,1,10)='#{period}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND substr(date_created,1,10)='#{date}'
                    ")
                end
                
                
            else
                if lab.length == 2 
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                elsif lab.length == 3
                    if lab != 'TDH' 
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                        ")
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                        ") 
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{date}'
                            AND test_types.name='#{test_type}'
                        ") 
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") 
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                end    
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{date}'
                    ")
                elsif lab.length == 3 
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}'
                        ") 
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO')
                        ")
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                elsif lab.length == 4 
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(date_created,1,10)='#{date}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND substr(date_created,1,10)='#{date}'
                    ")
                end       
            else
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                elsif lab.length == 3
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE substr(tracking_number,1,4)='X#{lab}'  AND test_types.name='#{test_type}'
                        ")
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO')  AND test_types.name='#{test_type}'
                        ")                  
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{date}'
                            AND test_types.name='#{test_type}'
                        ")
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,5)='X#{lab}'  AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,6)='X#{lab}'  AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                end     
            end
            
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end        
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end



    def query_lab_stats_total_orders_accepted
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
            
        if period != "false"
            if test_type.blank?
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                    ")
                elsif lab.length == 3
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                        ")
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                        ")                    
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                    ") 
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                    ") 
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                    ")
                end                
            else
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                elsif lab.length == 3
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                        ")
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ")
                    end
                    if lab == 'TDH'  
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                        ")                              
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                            AND test_types.name='#{test_type}'
                        ") 
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                end
            end
            
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                    ")
                elsif lab.length == 3
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2
                        ") 
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2
                        ")     
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                        ") 
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2
                    ") 
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                    ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2
                    ") 
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                    ")
                end
                
                
            else
                if lab.length == 2
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND test_types.name='#{test_type}'
                    ")
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                elsif lab.length == 3
                    if lab != 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND test_types.name='#{test_type}'
                        ") 
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ")
                    end
                    if lab == 'TDH'
                        res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND test_types.name='#{test_type}'
                        ")              
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                            AND test_types.name='#{test_type}'
                        ") 
                    end
                elsif lab.length == 4
                    res = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND test_types.name='#{test_type}'
                        ") 
                        response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id  
                            WHERE substr(tracking_number,1,5)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ")
                else
                    res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND test_types.name='#{test_type}'
                    ") 
                    response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,6)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ")
                end     
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end



    def query_lab_stats_total_orders_to_be_accepted
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
            
        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 
                            AND substr(date_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 
                            AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1
                    ") if lab != 'TDH'
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    INNER JOIN test_types ON test_types.id=tests.test_type_id  
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND test_types.name='#{test_type}'
                ") if (lab == 'ND' or lab == 'MH') 
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    INNER JOIN test_types ON test_types.id=tests.test_type_id  
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND test_types.name='#{test_type}'
                ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                        # Today's data
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end



    def query_lab_stats_total_orders_rejected
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"  
        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 
                            AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end  
            
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH'  AND specimen_status_id=3
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end



    def query_lab_stats_total_tests
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"

        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                ") if lab == 'TDH'
            end
            
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO')
                    ") if lab == 'TDH' 
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')                  
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'
            else 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end



        #  authorized
    def query_lab_stats_total_tests_verrified
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5
                            AND substr(tests.time_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH') 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end 
            if !response.blank?
                data_today = response[0]['total_count']
            end         
        end


        render plain: JSON.generate({data: data, today: data_today}) and return
    end
    

    # unauthorized
    def query_lab_stats_total_tests_with_results
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"

        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}' 
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            
            else 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND test_types.name='#{test_type}'
                    ") if lab != 'TDH'
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
            
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end



    def query_lab_stats_total_tests_waiting_results
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"

        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH' 
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3  AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH') 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3  AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3  AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end


        render plain: JSON.generate({data: data, today: data_today}) and return
    end



    def query_lab_stats_total_tests_rejected
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
        
        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{period}' 
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{period}' 
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 
                            AND substr(tests.time_created,1,10)='#{period}'  
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH') 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
    
            else 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                
            end
           if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end
    


    def query_lab_stats_total_tests_to_be_started
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
        
        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9)  AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9)  AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
                
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id                    
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9)  
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id                    
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9)  
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
                
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9)
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9)
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9)
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH') 
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                        AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end




    def query_lab_stats_total_tests_voided_failed
        date = Date.today 
        lab  = params[:lab_name]
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        data = "0"
        data_today = "0"
        
        if period != "false"
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{period}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    INNER JOIN test_types ON test_types.id=tests.test_type_id
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                        AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    INNER JOIN test_types ON test_types.id=tests.test_type_id
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                        AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH' 
                end
            
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') 
                            AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                    ") if lab == 'TDH'  
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}'
                    ") if lab == 'TDH'      
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                            AND test_types.name='#{test_type}'   
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                            AND test_types.name='#{test_type}'   
                    ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                            AND test_types.name='#{test_type}'
                        ") if lab == 'TDH'
                response = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            INNER JOIN tests ON tests.specimen_id=specimen.id 
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                                AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
                response = Speciman.find_by_sql("
                            SELECT count(*) AS total_count FROM specimen 
                            INNER JOIN tests ON tests.specimen_id=specimen.id
                            INNER JOIN test_types ON test_types.id=tests.test_type_id 
                            WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                                AND substr(tests.time_created,1,10)='#{date}' AND test_types.name='#{test_type}'
                        ") if lab == 'TDH'           
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            if !response.blank?
                data_today = response[0]['total_count']
            end
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end

    def query_last_sync 
        lab  = params[:lab_name]
        data = "0"
        res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' ORDER BY id DESC LIMIT 1") if (lab == 'ND' or lab == 'MH')
        res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,4)='X#{lab}' ORDER BY id DESC LIMIT 1") if (lab != 'TDH' and (lab != 'ND' and lab != 'MH'))
        res = Speciman.find_by_sql("SELECT * FROM specimen where (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') ORDER BY id DESC LIMIT 1") if lab == 'TDH'
        if !res.blank?
           data = res[0]['created_at']
        end
        render plain: JSON.generate({data: data, lab: lab}) and return
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

