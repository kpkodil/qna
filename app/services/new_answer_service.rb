class NewAnswerService
  def send_notification(new_answer)
    NewAnswerMailer.notificate(new_answer).deliver_later 
  end
end