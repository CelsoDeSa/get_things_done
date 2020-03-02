Rails.application.routes.draw do
  
  resources :projects, path: :projetos do
    resources :activities, path: :atividades
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'projects#index'
end
