class AnswersController < ApplicationController

  def new
    question
    @answer = Answer.new
  end

  def create
    authenticate_user!
    @answer = question.answers.build(answer_params)
    if @answer.save  
      redirect_to question
    else
      render 'questions/show'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
