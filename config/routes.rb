Rails.application.routes.draw do

  root to:'questions#index'
  
  devise_for :users

  mount ActionCable.server =>'/cable'

  resources :users, only: %i[] do
    get :rewards, on: :member
  end

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :delete_vote
    end
  end

  resources :questions, concerns: %i[ votable ] do
    resources :comments,shallow: true, only: %i[create]
    resources :answers, concerns: %i[ votable ], shallow: true, only: %i[create update destroy] do
      resources :comments,shallow: true, only: %i[create]
      patch "make_the_best", on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

end
