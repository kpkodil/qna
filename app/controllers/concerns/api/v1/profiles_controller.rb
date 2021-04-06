class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    authorize! :me, current_resource_owner
    render json: current_resource_owner
  end
end
