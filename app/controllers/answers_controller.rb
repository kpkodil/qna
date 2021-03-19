class AnswersController < ApplicationController

  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :question, only: %i[create destroy]
  before_action :answer, only: %i[update destroy make_the_best delete_attached_file]

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

  def make_the_best
    @prev_best_answer = @answer.question.best_answer
    if current_user&.resource_author?(@answer.question)
      @answer.make_the_best
      answer.question.reward.reward_the_user(@answer.user) if answer.question.reward.present?
    end  
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end 

  helper_method :answer

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url] )
  end
end
