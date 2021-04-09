class Api::V1::AnswersController < Api::V1::BaseController

  before_action :set_answer, only: %i[show create update destroy]
  before_action :set_question, only: %i[create]

  def show
    authorize! :show, @question
    render json: @answer, serializer: AnswerSerializer            
  end

  def create
    authorize! :create, Answer

    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    
    if @answer.save
      render json: @answer, serializer: AnswerSerializer, status: :created
    else
      render json: { message: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer

    if @answer.update(answer_params) 
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { message: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer
    if @answer.destroy
      render json: { message: 'answer was successfully deleted'}
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