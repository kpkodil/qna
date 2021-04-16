class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(author, question, new_answer)
    NewAnswerService.new.send_notification(author, question, new_answer)
  end
end
