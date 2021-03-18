require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE#delete_attached_file' do

    let(:answer) { create(:answer, user: author, question: question) }

    before do
      answer.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb'
                          )
    end 

    context 'User is an author of the resource (answer)' do

      before { login(author) }

      it 'deletes answer attached file' do
        answer.reload
        expect { delete :destroy, params: { id: answer,  file: answer.files.all.first }, format: :js }.to change(answer.files.all, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer, file: answer.files.all.first }, format: :js 

        expect(response).to render_template :destroy
      end
    end

    context 'User is a non-author of the answer' do
      
      before { login(user) }

      it ' tries to delete answer attached file' do
        expect { delete :destroy, params: { id: answer, file: answer.files.all.first }, format: :js }.to_not change(answer.files.all, :count)
      end

      it 're-renders destroy view' do
        delete :destroy, params: { id: answer, file: answer.files.all.first }, format: :js 

        expect(response).to render_template :destroy
      end
    end
  end
end