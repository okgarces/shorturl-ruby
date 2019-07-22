Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get '/urls', to: 'url#list'
  get '/urls/:id', to: 'url#find_by_short'
  post '/urls', to: 'url#create'
end
