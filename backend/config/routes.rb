Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'countries/random', to: 'countries#random'
      post 'quizzes/check', to: 'quizzes#check'
    end
  end
end
