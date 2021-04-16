require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswerService') }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:new_answer) { create(:answer, question: question, user: author) }

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'NewAnswerService#send_notification' do
    expect(service).to receive(:send_notification)
    NewAnswerJob.perform_now(author, question, new_answer)
  end
end
