Kanban::Application.routes.draw do

  get "home/index"

  root :to => 'home#index'

  resources :tasks

  resources :work_items

  resources :accounts do
    resources :projects
  end

  resources :work_types

	resources :steps

  resources :priorities

	devise_for :users, :controllers => { :registrations => "users/registrations" }

end
