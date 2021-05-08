Rails.application.routes.draw do
  root to: 'categories#index'

  resources :categories, only: [:index, :show] do

  end

  resources :articles, only: [:new, :create, :show] do
    resources :votes, only: [:create]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
