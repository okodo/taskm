Rails.application.routes.draw do
  get 'edit_password', to: 'sessions#edit_password', as: :edit_password
end
