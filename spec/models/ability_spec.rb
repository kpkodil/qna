require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should     be_able_to :read, :all }
    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)  { create :user }
    let(:other) { create(:user) }
    
    it { should_not be_able_to :manage, :all }
    it { should     be_able_to :read, :all }

    context 'questions' do
      let(:user_question)  { create(:question, user: user) }
      let(:other_question) { create(:question, user: other) }      

      context '#create' do
        it { should be_able_to :create, Question }
      end
      
      context '#update' do
        it { should     be_able_to :update, user_question }
        it { should_not be_able_to :update, other_question }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_question }
        it { should_not be_able_to :destroy, other_question }
      end
    end

    context 'answers' do
      let(:user_question)   { create(:question, user: user) }
      let(:other_question)   { create(:question, user: other) }

      let(:user_answer)  { create(:answer, question: user_question,  user: user) }
      let(:other_answer) { create(:answer, question: user_question, user: other) }

      context '#create' do
        it { should be_able_to :create, Answer }
      end
      
      context '#update' do
        it { should     be_able_to :update, user_answer }
        it { should_not be_able_to :update, other_answer }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_answer }
        it { should_not be_able_to :destroy, other_answer }
      end

      context '#make_the_best' do
        it { should     be_able_to :make_the_best, user_answer }
        it { should_not be_able_to :make_the_best, create(:answer, question: other_question,  user: user) }
      end
    end

    context 'comments' do
      context '#create' do
        it { should be_able_to :create, Comment }
      end
    end

    context 'links' do
      let(:user_question)    { create(:question, user: user) }
      let(:other_question)   { create(:question, user: other) }

      let(:user_link)  { create( :link, linkable: user_question) }
      let(:other_link) { create( :link, linkable: other_question) }


      context '#create' do
        it { should be_able_to :create, Link }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_link }
        it { should_not be_able_to :destroy, other_link }
      end
    end

    context 'attachements' do
      
      let(:user_question)  { create(:question, user: user) }
      let(:other_question) { create(:question, user: other) }

      let(:file) do 
        { io: File.open("/home/kpkodil/Изображения/example.jpg"), 
          filename: "example.jpg", 
          content_type: "image/jpg" }
      end

      let(:user_attacheble) do
        user_question.files.attach(file)
        user_question.files.last
      end

      let(:other_attacheble) do 
        other_question.files.attach(file) 
        other_question.files.last
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_attacheble }
        it { should_not be_able_to :destroy, other_attacheble }
      end
    end
    
    context 'voted' do
      let(:user_question)  { create(:question, user: user) }
      let(:other_question) { create(:question, user: other) }

      context '#vote_for' do
        it { should     be_able_to :vote_for, other_question }
        it { should_not be_able_to :vote_for, user_question }
      end

      context '#vote_against' do
        it { should     be_able_to :vote_for, other_question }
        it { should_not be_able_to :vote_for, user_question }
      end
      
      let!(:vote) { create(:vote, vote_value: 1, user_id: user.id, votable: other_question) }

      context '#delete_vote' do
        it { should be_able_to :delete_vote, other_question }
      end
    end
    context 'API' do
      context '#me' do
        it { should be_able_to :me, user}
      end
      context '#others' do
        it { should be_able_to :others, user}
      end
    end
  end
end