class NewAnswerMailer < ApplicationMailer
  def notificate(author, question, new_answer)
    @author = author
    @question = question
    @new_answer = new_answer

    mail to: author.email,
         template_path: 'mailers/new_answer'
  end
end
