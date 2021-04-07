class Api::V1::AnswersController < Api::V1::BaseController

  before_action :set_answer, only: %i[show create]
  before_action :set_question, only: %i[create]

  def show
    authorize! :show, current_resource_owner
    render json: @answer, serializer: AnswerSerializer            
  end

  def create
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    authorize! :create, current_resource_owner
    if @answer.save
      render json: @answer, serializer: AnswerSerializer, status: :created
    end
  end

  private

  def set_answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def set_question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url, :_destroy] )
  end
end