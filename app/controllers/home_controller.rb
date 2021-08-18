require 'date'
require 'json'

class HomeController < ApplicationController
    def index
        @labs = YAML.load_file "#{Rails.root}/public/molecular_labs.json"
        @genexpert_labs = YAML.load_file "#{Rails.root}/public/genexpert_labs.json"
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
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and lab != 'ND')

                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{period}'
                    ") if lab == 'TDH'
            else 
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    INNER JOIN test_types ON test_types.id=tests.test_type_id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                ") if (lab == 'ND' or lab == 'MH')

                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    INNER JOIN test_types ON test_types.id=tests.test_type_id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                ") if (lab != 'TDH' and lab != 'ND')

                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH'
                ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,4)='X#{lab}'
                ") if (lab != 'TDH' and lab != 'ND')

                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO')
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
                        WHERE substr(tracking_number,1,4)='X#{lab}'  AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and lab != 'ND')

                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO')  AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            

            if !res.blank?
                data = res[0]['total_count']
            end        
        end

        response = Speciman.find_by_sql("
                SELECT count(*) AS total_count FROM specimen 
                WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(date_created,1,10)='#{date}' AND substr(tracking_number,1,4)!='XNDH'
            ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                SELECT count(*) AS total_count FROM specimen 
                WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(date_created,1,10)='#{date}'
            ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                SELECT count(*) AS total_count FROM specimen 
                WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(date_created,1,10)='#{date}'
            ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}'
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 
                                AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2
                    ") if (lab != 'TDH' and lab != 'ND')

                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2
                    ") if lab == 'TDH'
            else
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND test_types.name='#{test_type}'
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND test_types.name='#{test_type}'
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            
            end

            if !res.blank?
                data = res[0]['total_count']
            end
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=2 AND substr(date_created,1,10)='#{date}'
                ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 
                            AND substr(date_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 
                            AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
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
                ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1
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
                ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            

            if !res.blank?
                data = res[0]['total_count']
            end
        end

        # Today's data
         response = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=1 AND substr(date_created,1,10)='#{date}'
                ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 
                            AND substr(date_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end  
            
            if !res.blank?
                data = res[0]['total_count']
            end
        else
            if test_type.blank?
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3
                    ") if (lab == 'ND' or lab == 'MH')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                
            end

            if !res.blank?
                data = res[0]['total_count']
            end
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                ") if lab != 'TDH'
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND specimen_status_id=3 AND substr(date_created,1,10)='#{date}'
                ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            
            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO')
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end
        end
         
        response = Speciman.find_by_sql("
                SELECT count(*) AS total_count FROM specimen 
                INNER JOIN tests ON tests.specimen_id=specimen.id 
                WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tests.time_created,1,10)='#{date}'
            ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                SELECT count(*) AS total_count FROM specimen 
                INNER JOIN tests ON tests.specimen_id=specimen.id 
                WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tests.time_created,1,10)='#{date}'
            ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                SELECT count(*) AS total_count FROM specimen 
                INNER JOIN tests ON tests.specimen_id=specimen.id 
                WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(tests.time_created,1,10)='#{date}'
            ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5
                            AND substr(tests.time_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id   
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
            end          
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=5 AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'
        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id
                        INNER JOIN test_types ON test_types.id=tests.test_type_id  
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end

            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            if !res.blank?
                data = res[0]['total_count']
            end
            
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                ") if lab =='ND'
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=4 AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH' 
            end
            
            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3  AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            
            end
            if !res.blank?
                data = res[0]['total_count']
            end
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=3 AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'
        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 
                            AND substr(tests.time_created,1,10)='#{period}'  
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            end
            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                
            end
           if !res.blank?
                data = res[0]['total_count']
            end
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND tests.test_status_id=8 AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'

        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{period}'
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                
            end
            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9)
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                            AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
            
            end
            if !res.blank?
                data = res[0]['total_count']
            end
        end
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab == 'ND' or lab == 'MH')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND (tests.test_status_id=2 OR tests.test_status_id=9) AND substr(tests.time_created,1,10)='#{date}'
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id 
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=2 OR tests.test_status_id=9) 
                        AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'
        if !response.blank?
            data_today = response[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{period}'
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
                ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        INNER JOIN test_types ON test_types.id=tests.test_type_id
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                            AND substr(tests.time_created,1,10)='#{period}' AND test_types.name='#{test_type}'
                    ") if lab == 'TDH'
                end
            
            if !res.blank?
                data = res[0]['total_count']
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') 
                            AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
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
                    ") if (lab != 'TDH' and lab != 'ND')
                res = Speciman.find_by_sql("
                        SELECT count(*) AS total_count FROM specimen 
                        INNER JOIN tests ON tests.specimen_id=specimen.id 
                        WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)
                            AND test_types.name='#{test_type}'
                        ") if lab == 'TDH'            
            end
            if !res.blank?
                data = res[0]['total_count']
            end
        end
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
                ") if (lab != 'TDH' and lab != 'ND')
        response = Speciman.find_by_sql("
                    SELECT count(*) AS total_count FROM specimen 
                    INNER JOIN tests ON tests.specimen_id=specimen.id
                    WHERE (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND (tests.test_status_id=6 OR tests.test_status_id=10 OR tests.test_status_id=7)  
                        AND substr(tests.time_created,1,10)='#{date}'
                ") if lab == 'TDH'
        if !response.blank?
            data_today = response[0]['total_count']
        end

        render plain: JSON.generate({data: data, today: data_today}) and return
    end

    def query_last_sync 
        lab  = params[:lab_name]
        data = "0"
        res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' ORDER BY id DESC LIMIT 1") if (lab == 'ND' or lab == 'MH')
        res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,4)='X#{lab}' ORDER BY id DESC LIMIT 1") if (lab != 'TDH' and lab != 'ND')
        res = Speciman.find_by_sql("SELECT * FROM specimen where (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') ORDER BY id DESC LIMIT 1") if lab == 'TDH'
        if !res.blank?
           data = res[0]['created_at']
        end
        render plain: JSON.generate({data: data}) and return
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

