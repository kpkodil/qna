require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :body }


  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it 'is the question best answer while self best is equal to true' do
    answer = create(:answer, best: true, user: author, question: question)

    expect(question.best_answer).to eq answer
  end

  it 'can be only one best answer in this question' do
    answer1 = create(:answer, best: true, user: author, question: question)
    answer2 = create(:answer, user: author, question: question) 

    answer2.update  best: true
    expect(question.answers.where(best: true).count).to eq 1
  end
end
