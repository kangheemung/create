Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth' => 'auth#create'
      resources :users do
        resources :microposts
         member do
           post 'follow'
           delete 'unfollow'
         end
      end
    end
  end
end