Rails.application.routes.draw do
<<<<<<< HEAD
  namespace :api do
    namespace :v1 do
      get 'sms/create'
    end
  end

=======
>>>>>>> edd6d424898e302b4db446263dd8e00fbba5bd15
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

  # root '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
