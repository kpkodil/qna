require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) {create(:user) }

  let(:question) { create(:question) }

  describe 'POST #create' do
    
    before { sign_in(user) }

    it 'associated with question' do
      post :create, params: valid_answer_params
      expect(assigns(:answer).question).to eq question
    end

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        expect { post :create, params: valid_answer_params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view ' do
        post :create, params: valid_answer_params
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_answer_params }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: invalid_answer_params
        expect(response).to render_template('questions/show')
      end
    end
  end

  private 

  def valid_answer_params
    { answer: attributes_for(:answer), question_id: question, user_id: user }
  end

  def invalid_answer_params
    { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user }
  end

end
