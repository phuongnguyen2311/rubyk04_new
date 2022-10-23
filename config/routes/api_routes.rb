Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    namespace :api do
      namespace :v1 do
        resources :users, only: [:index]
        resources :relationships, only: [:create, :destroy]
        resources :microposts, only: [:create, :destroy]
        resources :comments, only: [:create, :destroy]
        post "/login", to: "sessions#create"
      end
    end
  end
end