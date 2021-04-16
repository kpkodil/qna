class NewAnswerService
  def send_notification(author, question, new_answer)
    NewAnswerMailer.notificate(author, question, new_answer).deliver_later
  end
end