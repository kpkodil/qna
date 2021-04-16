class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(new_answer)
    NewAnswerService.new.send_notification(new_answer)
  end
end
