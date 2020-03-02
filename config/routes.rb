Rails.application.routes.draw do
  devise_for :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'rooms#join'

  resources :rooms, only: %i[show new create] do
    get 'join', on: :collection
    get 'lrc', on: :collection
  end
end
