Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    namespace :api do
      namespace :v1 do
        resources :users
      end
    end
  end
end