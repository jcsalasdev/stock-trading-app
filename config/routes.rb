Rails.application.routes.draw do
  devise_for :users
  scope :admin do
    resources :users#, only: [:index, :show, :edit, :update, :destroy, :new, :create]
  end
  get "/admin/pending_users", to: 'users#pending_users', as: 'pending_user'
  get "/admin/:id/pending_users", to: 'users#edit_pending_users', as: 'edit_pending_users'
  patch "/admin/pending_users/:id", to: 'users#update_pending_users', as: 'update_pending_user'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "pages#home"
end
