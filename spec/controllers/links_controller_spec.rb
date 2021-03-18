require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'DELETE#delete' do

    before do
      question.links.build( linkable: question, name: "Example link", url: "http://example.url")
      question.save
    end 

    context 'User is an author of the resource (question)' do

      before { login(author) }

      it 'deletes link' do
        question.reload
        expect { delete :destroy, params: { id: question,  link: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question, link: question.links.first }, format: :js 

        expect(response).to render_template :destroy
      end
    end

    context 'User is a non-author of the question' do
      
      before { login(user) }

      it ' tries to delete link' do
        expect { delete :destroy, params: { id: question, link: question.links.first }, format: :js }.to_not change(question.links, :count)
      end

      it 're-renders destroy view' do
        delete :destroy, params: { id: question, link: question.links.first }, format: :js 

        expect(response).to render_template :destroy
      end
    end
  end
end
