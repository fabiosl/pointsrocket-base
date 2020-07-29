Rails.application.routes.draw do

  mount Search::Engine => "/search"
end
