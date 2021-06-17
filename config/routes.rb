Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '' , to: 'home#index'

  post '/query_lab_stats_total_orders_submitted' => "home#query_lab_stats_total_orders"
  
  post '/query_lab_stats_total_orders_accepted' => "home#query_lab_stats_total_orders_accepted"
  post '/query_lab_stats_total_orders_to_be_accepted' => "home#query_lab_stats_total_orders_to_be_accepted"
  
  post '/query_lab_stats_total_orders_rejected' => "home#query_lab_stats_total_orders_rejected"

  post '/query_lab_stats_total_tests' => "home#query_lab_stats_total_tests"

  post '/query_lab_stats_total_tests_verrified' => "home#query_lab_stats_total_tests_verrified"
  
  post '/query_lab_stats_total_tests_with_results' => "home#query_lab_stats_total_tests_with_results"

  post '/query_lab_stats_total_tests_waiting_results' => "home#query_lab_stats_total_tests_waiting_results"

  post '/query_lab_stats_total_tests_rejected' => "home#query_lab_stats_total_tests_rejected"

  post '/query_lab_stats_total_tests_to_be_started' => "home#query_lab_stats_total_tests_to_be_started"

  post '/query_lab_stats_total_tests_voided_failed' => "home#query_lab_stats_total_tests_voided_failed"

  post '/query_lab_stats_last_sync' => "home#query_last_sync"

  post '/query_lab_stats_test_types' => "home#get_tests"
end