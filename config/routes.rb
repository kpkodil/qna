Rails.application.routes.draw do

  root to:'questions#index'
  
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      patch "make_the_best", on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

end
