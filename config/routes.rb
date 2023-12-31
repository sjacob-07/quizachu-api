Rails.application.routes.draw do
  #apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :v1, defaults: {format: :json} do
    post 'users', to: 'users#update'
    get 'user/:user_id/dashboard', to: 'users#dashboard'
    get '/assessments', to: 'assessments#index'
    get '/assessments/:assessment_id', to: 'assessments#show'
    post '/assessments/create', to: 'assessments#create'
    post '/assessments/:assessment_id/publish', to: 'assessments#publish'
    get '/assessments/:assessment_id/details', to: 'assessments#details'

    post '/user/assessment/:assessment_id/submit', to: 'user_assessments#submit_answers'
    get '/user/assessment/:assessment_id/results', to: 'user_assessments#view_answers'
  end
end
