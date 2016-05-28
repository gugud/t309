Rails.application.routes.draw do

  get    'categories',           to: 'categories#index'
  post   'categories',           to: 'categories#create'
  put    'categories/:id',       to: 'categories#update'
  delete 'categories/:id',       to: 'categories#destroy'
  get    'categories/:id/cases', to: 'categories#cases'

  post   'cases',     to: 'cases#create'
  get    'cases/:id', to: 'cases#show'
  put    'cases/:id', to: 'cases#update'
  delete 'cases/:id', to: 'cases#destroy'

end
