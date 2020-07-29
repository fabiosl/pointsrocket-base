Rails.application.routes.draw do
  get '/token-login', to: "tokens#index"
  post '/generate-token', to: "tokens#generate"
end
