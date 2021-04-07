class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :set_question, only: %i[new show answers]

  def new
    @question.links.build
    @question.build_reward
    authorize! :new, current_resource_owner
  end

  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    authorize! :show, current_resource_owner
    render json: @question, serializer: QuestionSerializer            
  end

  def create
    authorize! :create, current_resource_owner
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, serializer: QuestionSerializer, status: :created
    end
  end

  def answers
    @answers = @question.answers
    authorize! :index, current_resource_owner
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