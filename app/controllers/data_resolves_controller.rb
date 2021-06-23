require 'fuzzystringmatch'

class DataResolvesController < ApplicationController

    def index
        @anomaries = DataAnomaly.all
    end

    def show

        out_array_limit = 10
        match_value = 0.6

        @anomaly = DataAnomaly.find(params[:id])

        jarow = FuzzyStringMatch::JaroWinkler.create( :pure )

        data_type = @anomaly.data_type.downcase

        if data_type == "test_type"

            datar = Array.new()

            result_trimmed = Array.new()


            results_types = TestType.all

            for type in results_types do
                
                if jarow.getDistance(@anomaly.data,type.name).to_f >= match_value

                    class << type
                        attr_accessor :percentage
                    end

                    type.percentage = jarow.getDistance(@anomaly.data.downcase,type.name.downcase)

                    datar.append(type)
                    puts (type.percentage)

                end
                
            end 

            result_trimmed = datar.sort_by(&:percentage).reverse()
            @possibles = result_trimmed[0,out_array_limit]


        elsif data_type == "specimen_type"
            
            datar = Array.new()

            result_trimmed = Array.new()

            results_types = SpecimenType.all

            for type in results_types do
                
                if jarow.getDistance(@anomaly.data,type.name).to_f >= match_value

                    class << type
                        attr_accessor :percentage
                    end

                    type.percentage = jarow.getDistance(@anomaly.data.downcase,type.name.downcase)

                    datar.append(type)
                    puts (type.percentage)

                end
                
            end 
            
            result_trimmed = datar.sort_by(&:percentage).reverse()
            @possibles = result_trimmed[0,out_array_limit]

        end
        

        
    end

    def merge
        
    end
    
    
    
end
