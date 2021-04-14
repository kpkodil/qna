require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it 'calls ReputationService' do
    expect(ReputationService).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
