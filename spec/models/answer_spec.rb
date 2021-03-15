require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :body }


  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it "makes answer the best by method 'make_the_best'" do
    answer = create(:answer, user: author, question: question)    
    answer.make_the_best

    expect(answer.best).to eq true
  end

  it 'can be only one best answer in this question' do
    answer1 = create(:answer, best: true, user: author, question: question)
    answer2 = create(:answer, user: author, question: question) 

    answer2.update  best: true
    expect(question.answers.where(best: true).count).to eq 1
  end
end
