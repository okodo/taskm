Rails.application.routes.draw do
  scope module: 'auth' do
    resources :sessions, only: %i(new create) do
      get :destroy, on: :collection, as: :destroy
    end
    resources :passwords, only: %i(new create) do
      get :edit, on: :collection, as: :edit
      match :update, via: [:put, :patch], on: :collection
    end
    resources :users
  end

  namespace 'admin' do
    resources :tasks do
      put :start, on: :member
      put :finish, on: :member
      put :reopen, on: :member
    end
    root to: 'tasks#index'
  end

  root to: 'welcome#index'
end
