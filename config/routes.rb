class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end
Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    root to: 'static_pages#home'
    get 'static_pages/home'
    get 'static_pages/help'
    resources :posts
    resources :users
  
    get "/register", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    draw :admin_routes
    draw :api_routes
  end
end
