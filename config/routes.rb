Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/login', to: "login#login"

  resources :users do
    collection do
      patch :connected
      patch :disconnected
      get :self
    end
  end

  resources :friends do
    collection do
      get :sent
      get :received
      patch :accept
    end
  end

  resources :chats
  resources :messages 
end
