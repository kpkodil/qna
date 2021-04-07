class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :set_question, only: %i[show answers]

  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    authorize! :show, current_resource_owner
    render json: @question, serializer: QuestionSerializer            
  end

  def answers
    @answers = @question.answers
    authorize! :index, current_resource_owner
    render json: @answers, each_serializer: AnswerSerializer
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end