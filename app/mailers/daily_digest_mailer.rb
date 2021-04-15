class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @today_questions = questions

    mail to: user.email
  end
end
