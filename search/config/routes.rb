Search::Engine.routes.draw do
  resources :items, only: :index, path: '/' do
    get 'in_json', format: :json, on: :collection
  end
end
