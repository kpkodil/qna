require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe "POST #create" do

    before { login(user) }

    it 'creates a subscribe' do
      expect{ post :create, params: { question_id: question, user_id: user } }.to change(question.subscribes, :count).by(1)
    end

    it 'redirects to question' do
      post :create, params: { question_id: question, user_id: user }
      expect(response).to redirect_to(question_path(question))
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscribe) { create(:subscribe, subscriber: user, question: question) }

    before do
      login(user)
    end

    it 'deletes a subscribe'   do
      expect{ delete :destroy, params: { id: subscribe } }.to change(question.subscribes, :count).by(-1)      
    end

    it 'redirects to question' do 
      delete :destroy, params: { id: subscribe }
      expect(response).to redirect_to question_path(question)
    end
  end
end
