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
    resources :users do
      member do
        get :following, :followers
      end
    end
  
    get "/register", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    # resources :sessions, only: %i(new create destroy)
    resources :account_activations, only: :edit
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :microposts
    resources :relationships, only: [:create, :destroy]
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    draw :admin_routes
    draw :api_routes
  end
end
