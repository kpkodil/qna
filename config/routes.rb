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

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, only: %i[create update destroy] do
      patch "make_the_best", on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

end
