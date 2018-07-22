Rails.application.routes.draw do

  require 'sidekiq/web'
  namespace :api do
    namespace :v1 do
      get '/sms', :to => 'sms#create'
      post '/sms', :to => 'sms#create'
      resources :sms, only: [:create]
    end
  end
  
  resources :bajajs
  resources :tuktuks
  devise_for :admins

  authenticated :admin do
    mount Sidekiq::Web => '/sidekiq'
    root 'bajajs#index', as: :authenticated_admin
  end

   devise_scope :admin do
      get 'sign_in', to: 'devise/sessions#new'
      get 'sign_up', to: 'devise/registrations#new'
  end

  if Rails.env == "production"
    constraints :subdomain => "watamu" do
      post "*all", to: redirect { |params, req| "https://#{req.domain}/#{req.subdomain}/#{params[:all]}" }
    end
  end 

  root 'bajajs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# end
end
