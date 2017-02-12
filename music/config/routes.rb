Rails.application.routes.draw do
  get '/', to: 'services#new', as: 'new_service'
  post '/', to: 'services#create'
end
