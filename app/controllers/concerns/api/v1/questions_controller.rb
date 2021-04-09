class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :set_question, only: %i[new show answers update destroy]

  def new
    authorize! :new, Question
    @question.links.build
    @question.build_reward
  end

  def index
    authorize! :index, Question
    @questions = Question.all
    
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    authorize! :show, @question
    render json: @question, serializer: QuestionSerializer            
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { message: @question.errors.full_messages }, status: 400
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params) 
      render json: @question, serializer: QuestionSerializer, status: 200
    else
      render json: { message: @question.errors.full_messages }, status: 400
    end
  end

  def destroy
    authorize! :destroy, @question
    if @question.destroy
      render json: { message: 'question was successfully deleted'}, status: 200
    end
  end

  def answers
    authorize! :answers, @question
    @answers = @question.answers
    render json: @answers, each_serializer: AnswerSerializer
  end

  private

  def set_question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                      links_attributes: [:name, :url],
                                      reward_attributes: [:title, :image_url])
  end
end