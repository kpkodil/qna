class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions
  end
end