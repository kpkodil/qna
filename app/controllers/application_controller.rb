class ApplicationController < ActionController::Base

  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  private 

  def gon_user
    gon.user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exeption|
    redirect_to root_url, alert: exeption.message
  end
end
