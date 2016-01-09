Rails.application.routes.draw do
 
  root  'static_pages#home'

  resources :freshwaters, only: [:index, :show] do
    member do
      get :near
		end
	end
  
  resources :freshwater_ecoregions,   only: [:index, :show]
  
end
