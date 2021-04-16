class DailyDigestService
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, Question.today.to_a).deliver_later  
    end
  end
end