Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '' , to: 'home#index'
  get '/lims/qech' , to: 'home#qech'
  get '/lims/kch' , to: 'home#kch'
  get '/lims/mzimba-district-hospital' , to: 'home#mzimbadh'
  get '/lims/mzuzu-central-hospital' , to: 'home#mzuzuch'
  get '/lims/genexpert/:hospital' , to: 'home#genexpert'

  post '/query_lab_stats_total_orders' => "home#query_lab_stats_total_orders"
  get '/query_lab_stats_total_orders' => "home#query_lab_stats_total_orders"
  post '/query_last_sync' => "home#query_last_sync"
  post '/query_lab_stats_total_orders_accepted' => "home#query_lab_stats_total_orders_accepted"
  get '/query_lab_stats_total_orders_accepted' => "home#query_lab_stats_total_orders_accepted"

  post '/query_lab_stats_total_orders_rejected' => "home#query_lab_stats_total_orders_rejected"
  get '/query_lab_stats_total_orders_rejected' => "home#query_lab_stats_total_orders_rejected"

  post '/query_lab_stats_total_tests' => "home#query_lab_stats_total_tests"
  get '/query_lab_stats_total_tests' => "home#query_lab_stats_total_tests"

  get '/query_lab_stats_total_tests_verrified' => "home#query_lab_stats_total_tests_verrified"
  post '/query_lab_stats_total_tests_verrified' => "home#query_lab_stats_total_tests_verrified"
  
  get '/query_lab_stats_total_tests_with_results' => "home#query_lab_stats_total_tests_with_results"
  post '/query_lab_stats_total_tests_with_results' => "home#query_lab_stats_total_tests_with_results"

  get '/query_lab_stats_total_tests_waiting_results' => "home#query_lab_stats_total_tests_waiting_results"
  post '/query_lab_stats_total_tests_waiting_results' => "home#query_lab_stats_total_tests_waiting_results"

  get '/query_lab_stats_total_tests_rejected' => "home#query_lab_stats_total_tests_rejected"
  post '/query_lab_stats_total_tests_rejected' => "home#query_lab_stats_total_tests_rejected"

  get '/query_lab_stats_total_tests_to_be_started' => "home#query_lab_stats_total_tests_to_be_started"
  post '/query_lab_stats_total_tests_to_be_started' => "home#query_lab_stats_total_tests_to_be_started"

end
