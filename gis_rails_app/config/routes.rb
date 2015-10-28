Rails.application.routes.draw do
 
  root  'static_pages#home'

  resources :freshwaters,             only: [:index, :show]
  resources :freshwater_ecoregions,   only: [:index, :show]
  
  match '/about_project', to: 'static_pages#about_project', via: 'get'

end
