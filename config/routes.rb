Kanban::Application.routes.draw do

  match "home/index" => 'home#index', :via => :get, :as => :home

  root :to => 'home#index'

  resources :tasks

  resources :work_items

  resources :accounts do
    resources :projects do
      resources :steps
    end
  end

  resources :work_types



  resources :priorities

	devise_for :users, :controllers => { :registrations => "users/registrations" }

end
