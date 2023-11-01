Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      resources :users do
        resources :microposts
         member do
           get :following, :followers
         end
      end
    end
  end
end