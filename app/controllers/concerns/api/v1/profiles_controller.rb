class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    authorize! :me, current_resource_owner
    render json: current_resource_owner
  end

  def others
    authorize! :others, current_resource_owner
    @others = User.where.not(id: current_resource_owner.id)
    render json: @others, each_serializer: ProfileSerializer, root: 'others'
  end
end
