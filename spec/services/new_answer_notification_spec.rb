require 'rails_helper'

RSpec.describe NewAnswerService do 
  let(:author) { create(:user) }
  let(:subscribers) { create_list(:user, 2) }
  let(:question) { create(:question, user: author) }
  let!(:new_answer) { create(:answer, question: question, user: author) }
  let(:subscribe1) { create(:subscribe, user: subscribers.first, question: question)} 
  let(:subscribe2) { create(:subscribe, user: subscribers.second, question: question)}

  it "sends new answer notification to quesiton's subscribers" do
    subscribers.each do |subscriber| 
      expect(NewAnswerMailer).to receive(:notificate).with(subscriber, question, new_answer).and_call_original 
    end
    subject.send_notification(subscribers, question, new_answer)
  end
end 