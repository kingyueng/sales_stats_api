Rails.application.routes.draw do
  resources :products, only: %i[index show create update destroy]

  resource :reports, only: [] do
    get :monthly_sales
    get :top_products
  end
end
