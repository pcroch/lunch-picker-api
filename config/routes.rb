Rails.application.routes.draw do
  devise_for :users, skip: :all
  # root to: 'pages#home'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :lunches, only: [ :index, :show, :update , :create, :destroy ]
      resources :preferences, only: %i[index show update create destroy]
    end
  end
end
