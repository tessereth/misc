Rails.application.routes.draw do
  get '/', to: 'services#stats', as: 'stats'
  get '/new', to: 'services#new', as: 'new_service'
  post '/new', to: 'services#create'
  get '/songs', to: 'services#songs', as: 'songs'
  get '/services', to: 'services#services', as: 'services'
end
