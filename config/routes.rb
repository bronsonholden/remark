Rails.application.routes.draw do
  mount Searchjoy::Engine, at: "searchjoy" if Rails.env.development?

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "users", only: [:create, :show] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end

  get "/feed" => "feed#show", as: "feed"
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"

  resources :articles

  resource :blog, controller: "blog", only: [:index] do
    get "/", to: "blog#index"
    get "/:slug", to: "blog#show", as: "article"
  end

  resource :profile, controller: "profile", only: [:show, :edit, :update] do
    get :remarks
  end

  resources :remarks do
    get :debug, on: :member
    post :reindex, on: :member
    post :nlp, on: :member
    post :conversions_cache, on: :member
    post :photo_recognition, on: :member
    get :reactions, on: :member, to: "reactions#index"
    put :reactions, on: :member, to: "reactions#create"
    delete :reactions, on: :member, to: "reactions#destroy"
  end

  resources :searches, controller: "searches" do
    post "/convert", on: :member, to: "searches#convert"
  end

  resources :photos, only: :show

  root to: "splash#show", as: "splash"

  get "/control_panel", to: "control_panel#show"

  %w[404 422 500 503].each do |code|
    get code, to: "errors#show", code: code
  end
end
