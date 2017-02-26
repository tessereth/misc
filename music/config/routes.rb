Rails.application.routes.draw do
  get '/', to: 'services#new', as: 'new_service'
  post '/', to: 'services#create'
  get '/songs', to: 'services#songs', as: 'songs'
  get '/services', to: 'services#services', as: 'services'
end
