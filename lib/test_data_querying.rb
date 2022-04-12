module TestDataQuerying
    def tests_orders_sql_query(params, status="",queried_in="tests")
        select_sql_query =  "SELECT count(*) AS total_count FROM specimen"
        inner_join_tests_with_specimen = "INNER JOIN tests ON tests.specimen_id=specimen.id"
        inner_join_tests_with_test_types = "INNER JOIN test_types ON test_types.id=tests.test_type_id"
        period = params[:period]
        lab_x = params[:lab_name]
        test_type = params[:test_type].gsub('Aand','&')
        test_type_condition="AND test_types.name='#{test_type}'"
        period_condition = "AND substr(date_created,1,10)='#{period}'"
        queried_in = queried_in
        if queried_in=="tests"
            time_column = "tests.time_created"
            time_column = "tests.created_at" if lab_x == "CHSU"
        else
            time_column ="date_created"
            time_column = "specimen.created_at" if lab_x == "CHSU"
        end
        if period != "false"
            puts "period provided"
            if test_type.blank?
                puts "blank test type"
                condition = partial_sql_condition(params, period_condition=period_condition, test_type_condition="", status_condition=status, time_date_column=time_column)
                if queried_in=="tests"
                    innerjoin_and_select_query = select_and_innerjoin_query(select_sql_query,inner_join_tests_with_specimen)
                else 
                    innerjoin_and_select_query = select_and_innerjoin_query(select_sql_query)
                end
                sql_query = join_select_and_condition_query(innerjoin_and_select_query, condition)
            else
                puts "test type available"
                condition = partial_sql_condition(params, period_condition=period_condition, test_type_condition=test_type_condition, status_condition=status,time_date_column=time_column)
                innerjoin_and_select_query = select_and_innerjoin_query(select_sql_query,inner_join_tests_with_specimen,inner_join_tests_with_test_types)
                sql_query = join_select_and_condition_query(innerjoin_and_select_query, condition)
            end
        else 
            puts "period not provided"
            if test_type.blank?
                puts "blank test type"
                condition = partial_sql_condition(params, period_condition = "", test_type_condition="", status_condition=status,time_date_column=time_column)
                if queried_in=="tests"
                    innerjoin_and_select_query = select_and_innerjoin_query(select_sql_query,inner_join_tests_with_specimen)
                else 
                    innerjoin_and_select_query = select_and_innerjoin_query(select_sql_query)
                end
                sql_query = join_select_and_condition_query(innerjoin_and_select_query, condition)
            else
                puts "test type available"
                condition = partial_sql_condition(params,period_condition = "", test_type_condition=test_type_condition, status_condition=status,time_date_column=time_column)
                innerjoin_and_select_query = select_and_innerjoin_query(select_sql_query,inner_join_tests_with_specimen,inner_join_tests_with_test_types)
                sql_query = join_select_and_condition_query(innerjoin_and_select_query, condition)
            end
        end
    end

    def partial_sql_condition(params, period_condition = "", test_type_condition = "", status_condition = "",time_date_column)
        date = Date.today
        period = params[:period]
        test_type = params[:test_type].gsub('Aand','&')
        lab  = params[:lab_name]
        lab_length = lab.length
        sql_substr_index_end = lab_length + 1
        if lab_length == 2
            data_today_condition =  "WHERE substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(#{time_date_column},1,10)='#{date}' "+ status_condition +" " + test_type_condition
            data_periodic_condition =  "WHERE substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' " + period_condition + " "+ status_condition +" " + test_type_condition
        elsif lab_length ==3
            if (lab != 'TDH' or lab != 'NMT')
                puts "lenght of 3"
                data_today_condition = "WHERE substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' AND substr(#{time_date_column},1,10)='#{date}' "+ status_condition +" " + test_type_condition
                puts "today today of 3"
                data_periodic_condition = "WHERE substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' " + period_condition + " "+ status_condition +" " + test_type_condition
            end
            if lab == 'TDH'
                data_today_condition = "WHERE (substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' OR substr(tracking_number,1,3)='XTO') AND substr(#{time_date_column},1,10)='#{date}' "+ status_condition +" " + test_type_condition
                data_periodic_condition = "WHERE (substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' OR substr(tracking_number,1,3)='XTO') " + period_condition + " "+ status_condition +" " + test_type_condition
            end
            if lab == 'NMT'
                data_today_condition = "WHERE (substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' AND substr(tracking_number,1,#{sql_substr_index_end+1})!='XNMTH') AND substr(#{time_date_column},1,10)='#{date}' "+ status_condition +" " + test_type_condition
                data_periodic_condition = "WHERE (substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' AND substr(tracking_number,1,#{sql_substr_index_end+1})!='XNMTH') " + period_condition + " "+ status_condition +" " + test_type_condition
            end
        else
            data_today_condition = "WHERE substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' AND substr(#{time_date_column},1,10)='#{date}' "+ status_condition +" " + test_type_condition
            data_periodic_condition = "WHERE substr(tracking_number,1,#{sql_substr_index_end})='X#{lab}' " + period_condition + " "+ status_condition +" " + test_type_condition
        end
        data = { 
            data_today_condition: data_today_condition.squish,
            data_periodic_condition: data_periodic_condition.squish
         }
    end

    def select_and_innerjoin_query(select_query="", tests_with_specimen="", tests_with_test_types="")
        today_query = select_query+" "+ tests_with_specimen +" "+ tests_with_test_types
        periodic_query = select_query+" "+ tests_with_specimen +" "+ tests_with_test_types
        inner_joined_query = { 
            today_query: today_query.squish, 
            periodic_query: periodic_query.squish
         }
    end

    def join_select_and_condition_query(select_part,condition_part)
        full_query_today_data = select_part[:today_query]+" "+condition_part[:data_today_condition]
        full_query_periodic_data = select_part[:periodic_query]+" "+condition_part[:data_periodic_condition]
        query = { 
            query_for_today_data: full_query_today_data,
            query_for_periodic_data: full_query_periodic_data
        }
    end

    def self.last_sync_date(lab)
        data = "0"
        if lab.length == 2
            res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' ORDER BY id DESC LIMIT 1")
        elsif lab.length == 3
            if lab != 'TDH'
                res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,4)='X#{lab}' ORDER BY id DESC LIMIT 1") 
            end
            if lab == 'TDH'
                res = Speciman.find_by_sql("SELECT * FROM specimen where (substr(tracking_number,1,4)='X#{lab}' OR substr(tracking_number,1,3)='XTO') ORDER BY id DESC LIMIT 1") 
            end
        elsif lab.length == 4
            res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,5)='X#{lab}' ORDER BY id DESC LIMIT 1") 
        else
            res = Speciman.find_by_sql("SELECT * FROM specimen where substr(tracking_number,1,6)='X#{lab}' ORDER BY id DESC LIMIT 1") 
        end
    
        if !res.blank?
           data = res[0]['created_at']
        end
    end
end
