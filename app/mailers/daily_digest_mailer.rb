class DailyDigestMailer < ApplicationMailer
  def digest(user, today_questions)
    @today_questions = today_questions

    mail to: user.email,
         template_path: 'mailers/daily_digest'
  end
end
