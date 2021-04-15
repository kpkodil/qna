class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hey"
    
    mail to: user.email
  end
end
