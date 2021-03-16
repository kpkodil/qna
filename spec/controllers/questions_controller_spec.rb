require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, title: 'MyString', body: 'MyText', user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end  
      it 'render to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end 
    end
    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 're-renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    
    let(:author) {create(:user) }
    let!(:question) { create(:question, user: author) }

    context 'User is an author of the question' do

      before { login(author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'renders index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not an author of the question' do
      
      before { login(user) }
  
      it 'prevent deleting question by not author' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to show' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH#delete_attached_file' do

    let(:author) {create(:user) }
    let!(:question) { create(:question, user: author) }

    before do
      question.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb'
                          )
    end 

    context 'User is an author of the question' do

      before { login(author) }

      it 'deletes attached file in question' do
        expect { patch :delete_attached_file, params: { id: question, file_id: question.files.all.first }, format: :js }.to change(question.files.all, :count).by(-1)
      end

      it 'renders delete_attached_file view' do
        patch :delete_attached_file, params: { id: question, file_id: question.files.all.first }, format: :js 

        expect(response).to render_template :delete_attached_file
      end
    end

    context 'User is a non-author of the question' do
      
      before { login(user) }

      it 'tries to delete attached file in question' do
        expect { patch :delete_attached_file, params: { id: question, file_id: question.files.all.first }, format: :js }.to_not change(question.files.all, :count)
      end

      it 're-renders delete_attached_file view' do
        patch :delete_attached_file, params: { id: question, file_id: question.files.all.first }, format: :js 

        expect(response).to render_template :delete_attached_file
      end
    end
  end
end
