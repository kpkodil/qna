require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #new' do

    it 'renders new view' do
      get :new, params: { question_id: question }

      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    
    it 'associated with question' do
      post :create, params: valid_answer_params
      expect(assigns(:answer).question).to eq question
    end

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        expect { post :create, params: valid_answer_params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: valid_answer_params
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_answer_params }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: invalid_answer_params
        expect(response).to render_template :new
      end
    end
  end

  private 

  def valid_answer_params
    { answer: attributes_for(:answer), question_id: question }
  end

  def invalid_answer_params
    { answer: attributes_for(:answer, :invalid), question_id: question }
  end

end
