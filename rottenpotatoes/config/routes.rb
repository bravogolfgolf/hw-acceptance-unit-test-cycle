Rottenpotatoes::Application.routes.draw do
  root to: redirect('/movies')
  resources :movies
  get 'movies/similar/:id', to: 'movies#similar', as: 'similar'
end
