require 'rails_helper'
require 'spec_helper'
require Rails.root.join "spec/shared/models/votable.rb"
require Rails.root.join "spec/shared/models/commentable.rb"
require Rails.root.join "spec/shared/models/attachable.rb"

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it_behaves_like "votable"
  it_behaves_like "commentable"
  it_behaves_like "Attachable" do
    let(:resource_class) { "Answer".constantize }
  end
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it 'have the best answer while answer.best is equal to true' do
    answer = create(:answer, best: true, user: author, question: question)

    expect(question.best_answer).to eq answer
  end

  describe 'reputation' do
    let(:question) { build(:question, user: author) }
    
    it "calls ReputationJob" do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
