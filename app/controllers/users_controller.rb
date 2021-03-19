class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[rewards]

  def rewards
    @rewards = current_user&.rewards
  end
end
