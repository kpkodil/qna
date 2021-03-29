class AnswersChannel < ApplicationCable::Channel

  def subscribed
    stream_from "question_#{params[:question_id]}/answers"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
