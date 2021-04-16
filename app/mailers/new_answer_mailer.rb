class NewAnswerMailer < ApplicationMailer
  def notificate(subscriber, question, new_answer)
    byebug
    @subscriber = subscriber
    @question = question
    @new_answer = new_answer

    mail to: @subscriber.email,
       template_path: 'mailers/new_answer'
  end
end
