require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'POST#create' do
    
    before { login(user) }

    it 'associated with commentable' do
      post :create, params:  valid_comment_params, format: :json
  
      expect(assigns(:comment)).to eq question.comments.first
    end

    context 'with valid attributes' do

      it 'saves a new comment in the database' do
        expect { post :create, params: valid_comment_params, format: :json }.to change(question.comments, :count).by(1)
      end

      it 'gets response status 200' do
        post :create, params: valid_comment_params, format: :json
        
        expect(response.status).to eq(200)
      end    
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_comment_params, format: :json }.to_not change(question.comments, :count)
      end

      it 'gets response status 422' do
        post :create, params: invalid_comment_params, format: :json
    
        expect(response.status).to eq(422)
      end
    end
  end

  private 

  def valid_comment_params
    { comment: attributes_for(:comment), question_id: question.id }
  end


  def invalid_comment_params
    { comment: attributes_for(:comment, :invalid), question_id: question.id }
  end
end
