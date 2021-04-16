class NewAnswerService
  def send_notification(subscribers, question, new_answer)
    subscribers.each { |subscriber| NewAnswerMailer.notificate(subscriber, question, new_answer).deliver_later }
  end
end