require "json"
class BacklogDataEntryController < ApplicationController
    def get_bde_data
        lab = params[:lab_name]
        if lab.length == 2
            bde_data = Speciman.find_by_sql("
                SELECT specimen.tracking_number, specimen.date_created, specimen_types.name AS sample_type,
                test_types.name AS test_type FROM specimen
                INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                INNER JOIN tests ON tests.specimen_id = specimen.id
                INNER JOIN test_types ON test_types.id = tests.test_type_id
                WHERE substr(tracking_number,1,3)='X#{lab}' AND substr(tracking_number,1,4)!='XNDH' AND substr(tracking_number,-3)='BDE'
                "
            )
        
        elsif lab.length == 3
            if lab != 'NMT'
                bde_data = Speciman.find_by_sql("
                    SELECT specimen.tracking_number, specimen.date_created, specimen_types.name AS sample_type,
                    test_types.name AS test_type FROM specimen
                    INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                    INNER JOIN tests ON tests.specimen_id = specimen.id
                    INNER JOIN test_types ON test_types.id = tests.test_type_id
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tracking_number,-3)='BDE'
                    "
                )
            else
                bde_data = Speciman.find_by_sql("
                    SELECT specimen.tracking_number, specimen.date_created, specimen_types.name AS sample_type,
                    test_types.name AS test_type FROM specimen
                    INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                    INNER JOIN tests ON tests.specimen_id = specimen.id
                    INNER JOIN test_types ON test_types.id = tests.test_type_id
                    WHERE substr(tracking_number,1,4)='X#{lab}' AND substr(tracking_number,1,5)!='XNMTH' AND substr(tracking_number,-3)='BDE'
                    "
                )
            end
        else
            bde_data = Speciman.find_by_sql("
                SELECT specimen.tracking_number, specimen.date_created, specimen_types.name AS sample_type,
                test_types.name AS test_type FROM specimen
                INNER JOIN specimen_types ON specimen_types.id = specimen.specimen_type_id
                INNER JOIN tests ON tests.specimen_id = specimen.id
                INNER JOIN test_types ON test_types.id = tests.test_type_id
                WHERE substr(tracking_number,1,5)='X#{lab}' AND substr(tracking_number,-3)='BDE'
                "
            )
        end
        
        bde_hash ={}
        bde_arr = []
        bde_data.each do |data|
           bde_hash_data = {
               :tracking_number => data["tracking_number"],
               :date_created => data["date_created"].to_s.split(' ')[0],
               :sample_type => data['sample_type'],
               :test_type => data["test_type"]
            }
            bde_arr.push(bde_hash_data)
            # bde_hash[data["tracking_number"]] = [data["date_created"],data['sample_type'], data["test_type"]]
        end
        # puts bde_arr
        render plain: JSON.generate({data:bde_arr}) and return
    end
end