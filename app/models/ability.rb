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
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], { user_id: user.id }
  end
end
