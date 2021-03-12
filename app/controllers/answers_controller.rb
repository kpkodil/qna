class AnswersController < ApplicationController

  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :question, only: %i[create destroy]
  before_action :answer, only: %i[update destroy]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.resource_author?(@answer)
  end

  def destroy
    @answer.destroy if current_user.resource_author?(@answer)
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
