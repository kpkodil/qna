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
      link.linkable.user_id == user.id 
    end

    can :make_the_best, Answer do |answer|
      answer.question.user_id == user.id
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == user.id
    end

    can %i[vote_for vote_against delete_vote],  
          [Question, Answer] do |resource| 
            resource.user_id != user.id 
          end
  end
end
