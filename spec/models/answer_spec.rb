require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :body }


  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

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
  end
  
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
