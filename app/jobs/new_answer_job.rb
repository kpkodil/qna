class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(subscribers, question, new_answer)
    NewAnswerService.new.send_notification(subscribers, question, new_answer)
  end
end
