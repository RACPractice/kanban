Kanban::Application.routes.draw do

  match "home/index" => 'home#index', :via => :get, :as => :home

  root :to => 'home#index'

  resources :tasks

  resources :accounts do
    resources :projects do
      resources :steps do
        resources :work_items
      end
      resources :memberships
    end
  end

  resources :work_items
  match "work_items/update_positions" => 'work_items#update_positions', :via => :post, :as => :update_positions
  match "steps/update_positions" => 'steps#update_positions', :via => :post, :as => :update_steps_positions

  resources :steps
  resources :work_types

  resources :priorities

	devise_for :users, :controllers => { :registrations => "users/registrations" }

end
