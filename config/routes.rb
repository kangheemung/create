Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      resources :users do
        resources :microposts
      end
    end
  end
end