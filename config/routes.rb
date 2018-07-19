Rails.application.routes.draw do


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
    root 'bajajs#index', as: :authenticated_admin
  end

   devise_scope :admin do
      get 'sign_in', to: 'devise/sessions#new'
      get 'sign_up', to: 'devise/registrations#new'
  end

  root 'bajajs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# end
end
