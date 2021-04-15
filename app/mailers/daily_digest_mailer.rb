class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @today_questions = questions

    mail to: user.email,
         template_path: 'mailers/daily_digest'
  end
end
