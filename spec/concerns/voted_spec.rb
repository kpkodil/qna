require 'spec_helper'

shared_examples_for "voted" do
  let(:author) { create(:user) }
  let(:user) { create(:user) }

  klass_instance = (described_class.new).class.to_s.underscore.split('_')[0].singularize.to_sym


  case klass_instance
  when :question
    let!(:votable) { create(klass_instance, user: author) }
  when :answer
    let(:question) { create(:question, user: author) }
    let!(:votable) { create(klass_instance, user: author, question: question) }
  end

  describe "POST #vote_for" do
    before { login(user) }

    it 'creates a vote with +1 value' do
      expect{ post :vote_for, params: { id: votable }, format: :json }.to change(votable.votes.where(vote_value: 1), :count).by(1)

    end

    it 'gets response status 200' do
      post :vote_for, params: { id: votable }, format: :json   

      expect(response.status).to eq(200)
    end
  end

  describe "POST #vote_against" do
    before { login(user) }

    it 'creates a vote with -1 value' do
      expect{ post :vote_against, params: { id: votable }, format: :json }.to change(votable.votes.where(vote_value: -1), :count).by(1)      
    end

    it 'gets response status 200' do
      post :vote_for, params: { id: votable }, format: :json   
  
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE #delete_vote' do
    
    before do
      login(user) 
      post :vote_for, params: { id: votable }, format: :json
    end

    it 'deletes a vote'   do
      expect{ delete :delete_vote, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(-1)      
    end

    it 'gets response status 200' do
      delete :delete_vote, params: { id: votable }, format: :json   

      expect(response.status).to eq(200)
    end
  end
end