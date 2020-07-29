require 'sidekiq/web'
require 'sidekiq/cron/web'


class SubdomainConstraint
  def self.matches?(request)
    if ENV['DEV_ALWAYS_ACT_AS_SUBDOMAIN'] == 'true' and Rails.env.development?
      return true
    end

    blocked_subdomains = %w(www public admin)
    request.subdomain.present? && !blocked_subdomains.include?(request.subdomain)
  end
end

class RootDomainConstraint
  def self.matches?(request)
    if ENV['DEV_ALWAYS_ACT_AS_SUBDOMAIN'] == 'true' and Rails.env.development?
      return false
    end

    !request.subdomain.present?
  end
end

Rails.application.routes.draw do
  namespace :dashboard do
    get 'reports_controller/create'
  end

  constraints RootDomainConstraint do
    resources :domains, only: [:index, :new, :create, :destroy]
    post '/dashboard/community_invites' => 'dashboard/community_invites#create', as: 'domain_join'
  end

  get 'stop_mailing/:token' => 'stop_mailing#index', as: :stop_mailing
  delete 'stop_mailing/:token' => 'stop_mailing#destroy'

  get "select-social-accounts" => "select_social_accounts#index", as: :select_social_accounts_index
  post "select-social-accounts" => "select_social_accounts#create"

  get 'settings' => 'settings#index', as: :root_settings
  put 'settings' => 'settings#update', as: :update_root_settings

  get 'complete_registration', to: 'registrations#complete'
  put 'complete_registration', to: 'registrations#update', as: :update_complete_registration

  get "invites/:token", to: "invites#token", as: :invite_token

  resources :notifications, only: [:index] do
    collection do
      post :read_all
    end
    member do
      post :read
    end
  end

  authenticate :user, lambda {|u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
  }


  devise_scope :user do
    get "users/auth/:provider/session" => "users/omniauth_callbacks#passthru_with_session",
      as: :user_omniauth_authorize_session
    get "users/auth/:provider/multi_login" => "users/omniauth_callbacks#passthru_with_multi_login",
      as: :user_omniauth_authorize_multi_login
    get "users/auth/:provider/take_over" => "users/omniauth_callbacks#passthru_with_take_over",
      as: :user_omniauth_authorize_take_over
    get 'users/sign_out' => "devise/sessions#destroy"
    get 'token_login', to: 'users/tokens_login#new'
    post 'token_confirm', to: 'users/tokens_login#create'
    post 'users/token_login', to: 'users/tokens_login#login'
    get 'users/token_login', to: 'users/tokens_login#new'
  end

  if ENV['TRIVIAS_ENABLED'] == 'true'
    mount Trivias::Engine => '/dashboard/trivias'
  end

  if ENV['SEARCH_ENABLED'] == 'true'
    mount Search::Engine => '/dashboard/busca'
  end

  # root 'dashboard#index'
  # root 'domains#index'
  # get '/', to: 'domains#index'
  if not Rails.env.production?
    constraints SubdomainConstraint do
      match '/' => 'dashboard/timeline#index', via: [:get]
    end
  else
    match '/' => 'dashboard/timeline#index', :constraints => { :subdomain => /.+/ }, via: [:get]
  end

  get 'error' => 'error#index'

  resources :employee_advocacy_shares, only: [:show, :update], path: "v"

  get "employee_advocacy_email_preview/:id" => "employee_advocacy_email_preview#index"

  namespace :api do
    get "url_info_crawler" => "url_info_crawler#info"
    post "voucher/voucher_info/:voucher" => "voucher#voucher_info"
    post "es/get_publications_count" => "es#get_publications_count"
    resources :block_users, only: [:create]

    resource :tokens, only: [] do
      post :get_current_user_token, on: :collection
      get :token_login, on: :collection
    end

    resources :graph_facebook, only: [] do
      collection do
        get :first_page_insights
      end
    end
    resources :instagram, only: [] do
      collection do
        get :user
      end
    end
    get "analytics/info" => "analytics#info"
    resources :notifications do
      collection do
        post :mark_all_as_read
      end
    end
    resources :external_actions, only: [:create]
    resources :employee_advocacy_posts do
      collection do
        get :folders
      end

      resources :employee_advocacy_shares, only: [] do
        collection do
          get :shares_to_post
        end
      end
    end

    resources :employee_advocacy_shares, only: [] do
      collection do
        post :get_link
        post :create_share
        delete "delete_share/:id" => "employee_advocacy_shares#delete_share"
      end
    end

    resources :employee_advocacy_shares
    resources :domains do
      collection do
        get :current
      end
    end
    resources :courses do
      resources :chapters
    end
    resources :goals
    resources :categories
    resources :badges
    resources :campaigns
    resources :campaign_users, only: [:index, :create, :show]
    resources :trivias_questions do
      collection do
        post :sync
      end
    end
    resources :trails
    resources :franchisees
    resources :plans
    resources :challenges
    resources :challenge_users
    resources :hashtag_challenges
    resources :hashtag_challenge_users
    resources :broadcasts
    resources :invites do
      collection do
        post :bulk_invite
      end
    end
    resources :community_invites, only: [:index, :show] do
      member do
        post 'approve'
        post 'decline'
      end
    end
    # end
    scope :broadcasts do
      post "/reward" => 'broadcasts#reward', as: :broadcast_reward
    end
    resources :newsletters, only: [:create]
    resources :contacts, only: [:create]
    resources :reservas, only: [:create]
    resources :votes, only: [:create, :update, :destroy], :defaults => { :format => 'json' }
    resources :comments, :defaults => { :format => 'json' }
    resources :timeline_items, only: [:index], :defaults => { :format => 'json' } do
      patch 'hide', to: 'timeline_items#hide', on: :member
      patch 'pin', to: 'timeline_items#pin', on: :member
      patch 'remove_pin', to: 'timeline_items#remove_pin', on: :member
      get 'profile/:user_id', to: 'timeline_items#profile', on: :collection
      post 'report', to: 'timeline_items#report', on: :member
    end

    resources :complete_account_questions

    post '/posts/:id/view', to: 'posts#view', as: :post_view
    get '/posts/:id/views', to: 'posts#views', as: :post_views
    resources :devices, only: [] do
      collection do
        post :create_or_update
      end
    end

    resources :users, only: [] do
      collection do
        get :me
        put :me, to: "users#update_me"
        post :authenticate
      end
    end

    resources :activities, only: [:index]
  end

  resources :plans, only: :index, path: 'planos'

  get "erro-em-adicionar-rede-social" => 'social_error#index'

  resources :complete_registration, only: [:index], path: 'completar-registro' do
    collection do
      get :success, path: 'sucesso'
      match :payment, via: [:get, :patch, :post], path: 'pagamento'
      get :clear_voucher
      patch :index
    end
  end

  post 'moip_hook' => 'moip_hook#create'

  constraints SubdomainConstraint do
    get '/500', to: 'error#internal_error', as: 'internal_error'

    if ENV['HOME_ROUTE'].present?
      get 'dashboard' => ENV['HOME_ROUTE'].split('_HASHTAG_').join('#')
    else
      get 'dashboard' => 'dashboard#index'
    end
    # get '/', to: 'dashboard#index'
    scope :dashboard, module: :dashboard do
      get 'admin' => "admin#index", as: :dash_admin
      get 'old_dashboard' => "employee_advocacy#index"
      get 'dashboard/peer_recognition' => 'admin_dashboard#peer_recognition'
      get 'dashboard/hashtag_challenges' => 'admin_dashboard#hashtag_challenges'
      get 'dashboard/news' => 'admin_dashboard#news'
      get 'dashboard/general' => 'admin_dashboard#general'
      get 'dashboard/filter_peer_recognition' => 'admin_dashboard#filter_peer_recognition'
      get 'dashboard/generate_extract' => 'admin_dashboard#generate_extract'
      get 'dashboard', to: 'admin_dashboard#index', as: :dashboard_dashboard
      get 'dashboard_engagement', to: 'admin_dashboard#engagement'
      get 'admin/*path' => "admin#index"
      get "timeline" => "timeline#index", as: :timeline
      # get "timeline_item/:id" => "timeline#show"
      get "mensagem" => "messages#index", as: :messages
      get "conteudo" => "contents#show"
      get "em-desenvolvimento" => "wip#index", as: :wip
      get "analytics" => "mocks#analytics", as: :analytics
      get 'activities', to: 'timeline#activities'
      get 'carousel_activities', to: 'timeline#carousel_activities'

      scope :messages do
        get "unread", to: 'messages#unread', as: 'unread_messages'
      end
      # resources :messages
      resources :conversations do
        resources :messages do
          patch :read_all, to: 'messages#read_all', on: :collection
        end
      end

      resources :coin_gives, only: [:create]

      resources :memberships
      resources :posts
      resources :post_images, only: [:create, :destroy]

      resources :broadcasts, only: [:index, :show], path: 'transmissoes' do
        post 'reward' => 'broadcasts#reward', on: :collection
        post 'comment' => 'broadcasts#comment'
      end

      # get 'employee_advocacy' => 'employee_advocacy#index'

      namespace :employee_advocacy, path: :compartilhamentos do
        get "/" => "employee_advocacy#index"
        get "/*path" => "employee_advocacy#index"
      end

      # get 'admin/:domain_id/courses' => "admin#index"
      # get 'admin/:domain_id/courses/:id/edit' => "admin#index"

      match 'configuracoes' => 'dashboard#settings', via: [:get, :put], as: :settings
      post "cancel" => 'dashboard#cancel', as: :cancel
      post "activate" => 'dashboard#activate', as: :activate
      get "sem-permissao" => 'dashboard#unauth', as: :unauth
      get "assinatura" => 'dashboard#blocked_content', as: :blocked_content

      # get 'forum' => 'forum#index'
      # get 'forum/interna' => 'forum#show', as: :forum_show
      get 'ranking' => 'ranking#index', as: :ranking
      get 'ranking/filter' => 'ranking#filter', as: :filter
      get 'conquistas' => 'badges#index', as: :badges
      get 'usuarios/:id/conquistas' => 'users#badges', as: :user_badges
      post 'usuarios/:user_id/conquistas/:badge_id/associate' => 'badges#associate', as: :associate_badge
      post 'usuarios/:user_id/conquistas/:badge_id/deassociate' => 'badges#deassociate', as: :deassociate_badge
      get 'indicar' => 'indication#index', as: :indication
      get 'pontos' => 'points#index', as: :points
      get 'recompensas' => 'campaigns#index', as: :campaigns
      get 'premios' => 'campaigns#prizes', as: :prizes
      get 'comunidade' => 'forum#index', as: :forum
      get 'financeiro' => 'invoices#index', as: :invoices
      get 'kpi' => 'kpi#index', as: :kpi
      get 'kpi/colaborador' => 'kpi#colaborador', as: :kpi_colaborador
      get 'kpi/admin' => 'kpi#admin', as: :kpi_admin
      get 'loreal/colaborador' => 'loreal#colaborador', as: :loreal_colaborador
      get 'loreal/admin' => 'loreal#admin', as: :loreal_admin
      get 'alterar-cartao-de-credito' => 'change_credit_card#index', as: :change_credit_card
      match 'alterar-cartao-de-credito' => 'change_credit_card#update', via: [:post, :put, :patch]
      resources :users, only: [:index, :new, :create, :show, :destroy], path: 'usuarios' do
        collection do
          get 'back-previous-user', to: 'users#sign_in_previous_user'
          get :members, to: 'users#members'
        end
        member do
          get :avatar
        end
        resources :points, only: [:index], path: 'pontos'
      end

      resources :archives, only: [:show], path: :downloads
      resources :campaigns, only: [:show, :index], path: :recompensas
      resources :how_to_point_items, only: [:index], path: 'como-pontuar'

      resources :courses, only: [:index, :show], path: :curso do
        resources :chapter, only: [:show], path: :capitulo do
          resources :steps, path: :passo
        end
      end

      post 'steps/:id/point_video', to: 'steps#point_video'

      resources :questions, except: [:index, :new], path: :perguntas do
        post 'upvote' => 'questions#upvote', as: :upvote
        # post 'downvote' => 'questions#downvote', as: :downvote
      end

      resources :answers, except: [:index, :new, :show] do
        post 'upvote' => 'answers#upvote', as: :upvote
        # post 'downvote' => 'answers#downvote', as: :downvote
      end

      resources :question_answers, only: [:create]
      resources :trails, only: [:index], path: 'trilhas'

      the_challenges_path = ENV['FEEDBACK_FOR_CHALLENGE'] == 'true' ? "feedbacks" : "desafios"

      resources :challenges, only: [:index, :show], path: the_challenges_path do
        resources :challenge_users, only: [:create, :update, :destroy]
      end
      resources :hashtag_challenges, only: [:index, :show], path: "hashtag-challenges" do
        resources :hashtag_challenge_users, only: [:create, :update, :destroy]
      end

      resources :block_users, only: [:index, :create, :destroy]
    end
  end

  resources :transactions, only: [:create, :show, :update], path: 'transacoes' do
    collection do
      get 'notification', path: :notification
      post 'notification'
    end
  end

  resources :identities, only: [:destroy]
  root 'domains#index'
end
