class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[show new update destroy]
  def index
    @questions = Question.all
  end

  def show
    question
  end

  def new
    question
  end

  def edit;end 

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end 

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
