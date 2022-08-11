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

  get '/nlims_data_resolve' => "data_resolves#index"

  get '/resolve/:id' => "data_resolves#show"

  get '/merge/:id' => "data_resolves#merge"

  get '/get_viral_data' => "home#get_viral_data"
  
  root 'home#index'

  get "/get_bde_data" => "backlog_data_entry#get_bde_data"
  get "/search_eid_viral_data" => "home#search_eid_viral_data"

  # Monitoring status
  get '/add_new_site' => 'monitor_sync_status#add_site'
  post '/add_new_site' => 'monitor_sync_status#add_site'
  get '/site_status' => 'monitor_sync_status#sync_statuses'
  get '/site_details/:site_name/:site_code' => 'monitor_sync_status#site_sync_details'
  post '/site_details/:site_name/:site_code' => 'monitor_sync_status#site_sync_details'

  # R4H
  get '/r4h_dashboard' => 'r4h#index'
  get '/r4h_dashboard/total_orders' => 'r4h#total_orders'
  get '/r4h_dashboard/orders_collected' => 'r4h#orders_collected'
  get '/r4h_dashboard/orders_delivered_at_dho' => 'r4h#orders_delivered_at_dho'
  get '/r4h_dashboard/orders_delivered_at_molecular_lab' => 'r4h#orders_delivered_at_molecular_lab'
  get '/r4h_dashboard/results_ready_at_molecular' => 'r4h#results_ready_at_molecular'
  get '/r4h_dashboard/dispatched_results_at_molecular' => 'r4h#dispatched_results_at_molecular'
  get '/r4h_dashboard/:site_name' => 'r4h#total_orders'
end
