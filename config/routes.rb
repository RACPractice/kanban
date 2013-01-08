Kanban::Application.routes.draw do
  resources :tasks


  resources :work_items


  resources :projects


  resources :accounts


  resources :work_types
	resources :steps
  resources :priorities

  get "home/index"

	devise_for :users, :controllers => { :registrations => "users/registrations" }

  root :to => 'home#index'
end
