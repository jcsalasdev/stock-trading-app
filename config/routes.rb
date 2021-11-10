Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy, :edit]
  resources :transaction
  devise_for :users
  scope :admin do
    resources :users#, only: [:index, :show, :edit, :update, :destroy, :new, :create]
  end
  get "/admin/pending_users", to: 'users#pending_users', as: 'pending_user'
  get "/admin/:id/pending_users", to: 'users#edit_pending_users', as: 'edit_pending_users'
  patch "/admin/pending_users/:id", to: 'users#update_pending_users', as: 'update_pending_user'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'
  get 'buy_stock', to: 'stocks#buy'
  get 'sell_stock', to: 'stocks#sell'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "pages#home"
end
