class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions
  end

  def answers
    @question = Question.find(params[:id])
    @answers = @question.answers
    authorize! :index, current_resource_owner
    render json: @answers, each_serializer: AnswerSerializer
  end
end