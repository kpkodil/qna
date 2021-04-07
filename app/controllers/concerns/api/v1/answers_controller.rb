class Api::V1::AnswersController < Api::V1::BaseController

  before_action :set_answer, only: %i[show]

  def show
    authorize! :show, current_resource_owner
    render json: @answer, serializer: AnswerSerializer            
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end
end