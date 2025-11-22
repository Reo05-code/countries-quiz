Rails.application.routes.draw do
  get '/health', to: 'health#index'

  namespace :api do
    namespace :v1 do
      get 'countries/random', to: 'countries#random'
      post 'quizzes/check', to: 'quizzes#check'
      get 'user_flags', to: 'user_flags#index'
    end
  end
end
