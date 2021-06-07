Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '' , to: 'home#index'
  get '/lims/qech' , to: 'home#qech'
  get '/lims/kch' , to: 'home#kch'
  get '/lims/mzimba-district-hospital' , to: 'home#mzimbadh'
  get '/lims/mzuzu-central-hospital' , to: 'home#mzuzuch'

end
