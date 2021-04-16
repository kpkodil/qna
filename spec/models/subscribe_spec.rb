require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :user }
  it { should validate_presence_of :question }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:subscribe) { create(:subscribe, question: question, user: user) }

  it 'validates uniqueness of user-question pair' do
    expect { Subscribe.create(question: question, user: user) }.to_not change(question.subscribes, :count)
  end
end
