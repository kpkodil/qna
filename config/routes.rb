require 'sidekiq/web'

Rails.application.routes.draw do
  
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'  
  end

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
    resources :subscribes, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[] do
        get :me, on: :collection
        get :others, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[show create update destroy]
        get :answers, on: :member
      end
    end
  end

end
