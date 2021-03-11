require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) {create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    
    before { login(author) }

    it 'associated with question' do
      post :create, params: valid_answer_params, format: :js
      expect(assigns(:answer).question).to eq question
    end

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        expect { post :create, params: valid_answer_params, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view ' do
        post :create, params: valid_answer_params, format: :js
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_answer_params, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create view' do
        post :create, params: invalid_answer_params, format: :js
        expect(response).to render_template(:create)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'User is an author of the answer' do
      before { login(author) }

      let!(:answer) { create(:answer, user: author, question: question) }

      it 'delete the answer from the database' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view ' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(question_path(answer.question))
      end
    end

    context 'User is not an author of the answer' do
      before { login(user) }

      let!(:answer) { create(:answer, user: author, question: question) }

      it 'prevent deleting answer by not author' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(question_path(answer.question))
      end
    end
  end

  private 

  def valid_answer_params
    { answer: attributes_for(:answer), question_id: question, user_id: author }
  end

  def invalid_answer_params
    { answer: attributes_for(:answer, :invalid), question_id: question, user_id: author }
  end

end
