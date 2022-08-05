Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    namespace :admin do
      resources :users
    end
  end
end