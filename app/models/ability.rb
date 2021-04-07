# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    guest_abilities
    if user
      user.admin? ? admin_abilities : user_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create,  [Question, Answer, Comment, Link]
    can :update,  [Question, Answer],                         { user_id: user.id }
    can :destroy, [Question, Answer, Comment],                { user_id: user.id }
    can :rewards,  User,                                      { user_id: user.id }

    can :destroy, Link do |link|
      user.resource_author?(link.linkable) 
    end

    can :make_the_best, Answer do |answer|
      user.resource_author?(answer.question) 
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.resource_author?(attachment.record)
    end

    can :vote_for, [Question, Answer] do |resource| 
      !user.resource_author?(resource) 
    end
    can :vote_against, [Question, Answer] do |resource| 
      !user.resource_author?(resource) 
    end

    can :delete_vote, [Question, Answer] do |resource|
      resource.votes.find_by(user_id: user.id)
    end  
    
    can %i[me others], User do |profile|
      profile.id == user.id
    end

    can %i[index new create show answers], User do |profile|
      profile.id == user.id
    end
  end
end
