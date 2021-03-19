require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)      {create(:user) }
  let(:author)   { create(:user) }
  let(:question) { create(:question,                               user: author) }
  let(:answer)   { create(:answer, best: true, question: question, user: user) }
  let(:reward)   { create(:reward,             question: question, user: user) }

  describe 'GET #rewards' do
    let(:rewards) { create_list(:reward, 3, question: question, user: user) }
  
    before do 
      sign_in(user)
      get :rewards, params: { id: user} 
    end 

    it "populates an array of user's rewards" do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders rewards view' do
      expect(response).to render_template :rewards
    end
  end
end
