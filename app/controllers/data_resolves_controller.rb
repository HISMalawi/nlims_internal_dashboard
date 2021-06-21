class DataResolvesController < ApplicationController

    def index
        @anomaries = DataAnomaly.all
    end

    def show

        puts '-------------------'
        puts params[:id]
        
    end
    
    
end
