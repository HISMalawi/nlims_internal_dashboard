class HomeController < ApplicationController

    def index 
        data = {
            sites: ['ekwendeni', 'chiwavi', 'area 28']
        }
        # render json: data
    end

    def qech
        data = {
            total_orders_submitted:350, total_orders_accepted: 300,
            total_orders_rejected: 50, total_tests: 1000,
            total_tests_verrified: 800, total_tests_with_results:700,
            total_tests_rejected: 100, total_tests_waiting_results: 50,
            total_tests_to_be_started: 70, timeline: 'June 2017',
            sites: ['ekwendeni', 'chiwavi', 'area 28','ekwandeni', 'chiwevi', 'area 18']
        }
        render json: data
    end

    def kch
        data = {
            total_orders_submitted:33350, total_orders_accepted: 33300,
            total_orders_rejected: 3350, total_tests: 331000,
            total_tests_verrified: 33800, total_tests_with_results:33700,
            total_tests_rejected: 33100, total_tests_waiting_results: 3350,
            total_tests_to_be_started: 3370, timeline: 'June 2017'
        }
        render json: data
    end

    def mzuzuch
        data = {
            total_orders_submitted:11350, total_orders_accepted: 11300,
            total_orders_rejected: 1150, total_tests: 111000,
            total_tests_verrified: 11800, total_tests_with_results:11700,
            total_tests_rejected: 11100, total_tests_waiting_results: 1150,
            total_tests_to_be_started: 1170, timeline: 'June 2017'
        }
        render json: data
    end

    def mzimbadh
        data = {
            total_orders_submitted:88350, total_orders_accepted: 88300,
            total_orders_rejected: 8850, total_tests: 881000,
            total_tests_verrified: 88800, total_tests_with_results:88700,
            total_tests_rejected: 88100, total_tests_waiting_results: 8850,
            total_tests_to_be_started: 8870, timeline: 'June 2017'
        }
        render json: data
    end
end
