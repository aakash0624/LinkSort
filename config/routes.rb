Rails.application.routes.draw do

  resources :users

  root "urls#index"  
  resources :urls, only: [:create, :show, :index, :destroy] do
    collection do
      get :top_urls
      get :search
      get :top_level_domain
    end
  end

  get '/:url_id' => "redirects#redirect"



  

end
