require 'rails_helper'
require 'spec_helper'
require Rails.root.join "spec/shared/models/votable.rb"
require Rails.root.join "spec/shared/models/commentable.rb"
require Rails.root.join "spec/shared/models/attachable.rb"

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it { should have_many(:links).dependent(:destroy) }
  
  it_behaves_like "votable"
  it_behaves_like "commentable"
  it_behaves_like "Attachable" do
    let(:resource_class) { "Answer".constantize }
  end
  
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }


  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:reward) { create(:reward, question: question) }

  describe "'make_the_best' method " do
    
    let!(:answer1) { create(:answer, best: true, user: author, question: question) }
    let!(:answer2) { create(:answer, user: author, question: question) }

    it "makes answer the best" do
      answer2.make_the_best

      expect(answer2).to be_best
    end

    it 'set only one best answer in this question' do 
      answer2.update(best: true)

      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'change first best answer for question to non-best' do
      answer2.make_the_best
      answer1.reload

      expect(answer1).to_not be_best
    end

    it "rewards the best answer's user " do
      answer2.make_the_best

      expect(author.rewards.first).to eq reward
    end
  end
end
