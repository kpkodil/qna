Rails.application.routes.draw do

  use_doorkeeper
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

  concern :commentable do
    resources :comments,shallow: true, only: %i[create]
  end

  resources :questions, concerns: %i[ votable commentable ] do
    resources :answers, concerns: %i[ votable commentable ], shallow: true, only: %i[create update destroy] do
      patch "make_the_best", on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[] do
        get :me, on: :collection
        get :others, on: :collection
      end

      resources :questions, only: %i[index show create] do
        resources :answers, shallow: true, only: %i[show create]
        get :answers, on: :member
      end
    end
  end

end
