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

  post '/query_lab_stats_total_tests' => "home#query_lab_stats_total_tests"
  get '/query_lab_stats_total_tests' => "home#query_lab_stats_total_tests"

  get '/query_lab_stats_total_tests_verrified' => "home#query_lab_stats_total_tests_verrified"
  post '/query_lab_stats_total_tests_verrified' => "home#query_lab_stats_total_tests_verrified"
  
end
