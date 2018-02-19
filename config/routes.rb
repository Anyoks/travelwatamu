Rails.application.routes.draw do
  devise_for :admins

  authenticated :admin do
    root 'bajajs#index', as: :authenticated_admin
  end

  # root '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
