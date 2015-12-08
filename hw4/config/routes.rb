Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  #root :to => '/movies'
  root 'movies#index'
  get '/movies/search_director(/:id)', to: 'movies#search_director', as: 'search_director'
end
