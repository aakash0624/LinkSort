Rails.application.routes.draw do

  root "users#index"
  resources :users

  root "urls#index"  
  resources :urls, only: [:create, :show, :index, :destroy] do
    collection do
      get :top_urls
      get :search
      get :top_level_domain
    end
  end

  root "urls#index"
  get '/:url_id' => "redirects#redirect"



  

end
