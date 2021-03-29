require 'rails_helper'
require 'spec_helper'
require Rails.root.join "spec/concerns/votable_spec.rb"

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it_behaves_like "votable"
  it_behaves_like "commentable"
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it 'have the best answer while answer.best is equal to true' do
    answer = create(:answer, best: true, user: author, question: question)

    expect(question.best_answer).to eq answer
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
