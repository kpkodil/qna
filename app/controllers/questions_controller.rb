class QuestionsController < ApplicationController

  include Voted
  
  before_action :authenticate_user!, except: %i[index show create update deestroy ]
  before_action :question, only: %i[show new update destroy delete_attached_file]

  after_action :publish_question, only: %i[create]


  def new
    @question.links.build
    @question.build_reward
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    @comment = @question.comments.build(user: current_user)
  end
  
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.resource_author?(@question)
  end

  def destroy
    if current_user.resource_author?(@question)
      @question.destroy
      redirect_to questions_path, notice: "Question was successfully destroyed."
    else
      redirect_to question_path(@question), notice: "You are not author of this Question!"
    end
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', { question: @question, question_path: question_path(question).to_s }
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
    gon.question_id = @question.id
  end 

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [], 
                                      links_attributes: [:name, :url],
                                      reward_attributes: [:title, :image_url] )
  end
end
