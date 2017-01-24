Rails.application.routes.draw do
  get '/livestream', to: 'welcome#livestream'
  get '/eventslides', to: 'welcome#eventslides'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
