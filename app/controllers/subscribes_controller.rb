class SubscribesController < ApplicationController

  before_action :question

  authorize_resource 

  def create
    @subscribe = @question.subscribes.build(subscriber: current_user)
    if @subscribe.save
      redirect_to question_path(@question)
    end
  end

  def destroy
    @subscribe = Subscribe.find(params[:id])&.destroy
    @subscribe.destroy
    redirect_to question_path(@question)
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Subscribe.find(params[:id]).question
  end
end
