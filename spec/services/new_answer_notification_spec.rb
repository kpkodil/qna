require 'rails_helper'

RSpec.describe NewAnswerService do 
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:new_answer) { create(:answer, question: question, user: author) }


  it "sends new answer notification to quesiton's author" do
    expect(NewAnswerMailer).to receive(:notificate).with(author, question, new_answer).and_call_original
    subject.send_notification(author, question, new_answer)
  end
end 