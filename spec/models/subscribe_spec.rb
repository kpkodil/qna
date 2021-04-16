require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should belong_to :subscriber }
  it { should belong_to :question }
  it { should validate_presence_of :subscriber }
  it { should validate_presence_of :question }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:subscribe) { create(:subscribe, question: question, subscriber: user) }

  it 'validates uniqueness of user-question pair' do
    expect { Subscribe.create(question: question, subscriber: user) }.to_not change(question.subscribes, :count)
  end
end
