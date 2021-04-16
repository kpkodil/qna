require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswerService') }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:new_answer) { create(:answer, question: question, user: author) }
  let(:subscribers) { create_list(:user, 2) }
  let(:subscribe1) { create(:subscribe, user: subscribers.first, question: question)} 
  let(:subscribe2) { create(:subscribe, user: subscribers.second, question: question)}

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'NewAnswerService#send_notification' do
    expect(service).to receive(:send_notification)
    NewAnswerJob.perform_now(new_answer)
  end
end
