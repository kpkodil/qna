require 'rails_helper'

RSpec.describe NewAnswerService do 
  let(:author) { create(:user) }
  # let(:subscribers) { create_list(:user, 2) }
  let(:question) { create(:question, user: author) }
  let!(:new_answer) { create(:answer, question: question, user: author) }
  # let(:subscribe1) { create(:subscribe, user: subscribers.first, question: question)} 
  # let(:subscribe2) { create(:subscribe, user: subscribers.second, question: question)}

  it "sends new answer notification to question's subscribers" do

    expect(NewAnswerMailer).to receive(:notificate).with(new_answer).and_call_original 
    
    subject.send_notification(new_answer)
  end
end 