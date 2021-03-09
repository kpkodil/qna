class AnswersController < ApplicationController

  before_action :question, only: %i[show new update destroy]

  def new
    question
    answer
  end

  def create
    authenticate_user!
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    if @answer.save  
      redirect_to question
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.is_resource_author?(answer)
      answer.destroy
      redirect_to answer.question, notice: "Answer was successfully destroyed."
    else
      redirect_to answer.question, notice: "You are not author of this answer!"
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end 

  helper_method :answer

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
