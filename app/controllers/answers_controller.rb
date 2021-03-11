class AnswersController < ApplicationController

  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :question, only: %i[create destroy]
  before_action :answer, only: %i[update destroy]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save
  end

  def edit
    
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.resource_author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer was successfully destroyed.'
    else
      redirect_to @answer.question, notice: 'You are not author of this answer!'
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
