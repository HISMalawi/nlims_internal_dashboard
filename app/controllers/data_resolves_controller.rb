require 'similar_text'

class DataResolvesController < ApplicationController

    def index
        @anomaries = DataAnomaly.all
    end

    def show

        def search(anomaly_id,out_array_limit,match_percent)


            anomaly = DataAnomaly.find(anomaly_id)
          
            data_type = anomaly.data_type.downcase

            datar = Array.new()

            result_trimmed = Array.new()



            if data_type == 'test type' 


                results_types = TestType.all
    
                for type in results_types do
    
                    if (anomaly.data.downcase.similar(type.name.downcase).to_d >= match_percent)
    
                        class << type
                            attr_accessor :percentage
                        end
    
                        type.percentage = anomaly.data.similar(type.name).to_d 
    
                        datar.append(type)
    
                    end
                    
                end 
    
                result_trimmed = datar.sort_by(&:percentage).reverse()

                return possibles = result_trimmed[0,out_array_limit]
    
    
            elsif data_type == 'specimen type'

    
                results_types = SpecimenType.all
    
                for type in results_types do
                    
                    if (anomaly.data.downcase.similar(type.name.downcase).to_d >= match_percent)
    
                        class << type
                            attr_accessor :percentage
                        end
    
                        type.percentage = anomaly.data.similar(type.name).to_d 
    
                        datar.append(type)
                    
    
                    end
                    
                end 
                
                result_trimmed = datar.sort_by(&:percentage).reverse()

                return possibles = result_trimmed[0,out_array_limit]
    
            end

        end

        @anomaly = DataAnomaly.find(params[:id])

        out_array_limit = 10
        match_percent = 100.0

        search_data = search(params[:id],out_array_limit,match_percent)

        counter = 1

        while search_data.length() < 10 and counter < 100
           
            search_data = search(params[:id],out_array_limit,match_percent)

            counter = counter + 1

            match_percent = match_percent - 1
            
        end    
        
        filtered_search_data = Array.new()

        for item in search_data
            
            if item.percentage < 25.0

                puts (item.percentage)
            else
                
                filtered_search_data.append(item)
            end  
            

        end

        @possibles = filtered_search_data

    end

    def merge
        
    end
    
    
    
end
