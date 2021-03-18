class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show create update deestroy ]
  before_action :question, only: %i[show new update destroy delete_attached_file]

  def new
    @question.links.build
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
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
    if current_user.resource_author?(question)
      question.destroy
      redirect_to questions_path, notice: "Question was successfully destroyed."
    else
      redirect_to question_path(question), notice: "You are not author of this Question!"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end 

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                      files: [], links_attributes: [:name, :url] )
  end
end
