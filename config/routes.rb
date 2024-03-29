Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  
  devise_for :users
  
  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
  resources :book_comments, only: [:create, :destroy]
  resource :favorites, only: [:create, :destroy]
end
  resources :users, only: [:index, :show, :edit, :update] do
  resource :relationships, only: [:create, :destroy]
  get "followers" => "relationships#followers", as: "followers"
  get "following" => "relationships#following", as: "following"
  get "search" => "users#search"
end
  get "search", to: "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'tagsearches/search', to: 'tagsearches#search'
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]
  resources :groups, only:  [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
  end
end