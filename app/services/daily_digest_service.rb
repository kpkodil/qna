class DailyDigestService
  def send_digest
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, today_questions).deliver_later  
    end
  end

  private

  def today_questions
    @today_questions = []
    Question.find_each(batch_size: 500) do |question| 
      @today_questions << question if question.created_at.today? 
    end
    @today_questions
  end
end