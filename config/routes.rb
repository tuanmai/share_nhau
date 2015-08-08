module Api::Subdomain
   def self.matches?(request)
     return true
   end
end

Rails.application.routes.draw do
  devise_for :users

  scope module: 'api/v1', path: 'v1' do
    resources :sessions, only: [:create]
    resources :events, only: [:create, :index, :show]
    resources :rsvps, only: [:create, :update, :show]
    resources :bills, only: [:create, :show, :update]
  end
end
