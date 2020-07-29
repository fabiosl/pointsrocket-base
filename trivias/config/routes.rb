Trivias::Engine.routes.draw do

  namespace :api do
    resources :questions, only: [] do
      get :random_question, on: :collection
    end

    resources :answers

    resources :plays, only: [] do
      post :block, on: :member
    end
  end

	resources :trivias, path: '/' do
    resources :questions

    get :make_trivia, on: :collection

    get "answer_trivia" => "answer_trivia#index", on: :member, as: :answer
  end


  resources :user_trivias
end
