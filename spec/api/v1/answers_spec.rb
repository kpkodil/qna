require 'rails_helper'
require Rails.root.join "spec/shared/api_authorization.rb"

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json" } }

  let(:access_token) { create(:access_token) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answer_id) { answer.id }


describe 'GET api/v1/answers/answer_id' do
    let(:api_path) { "/api/v1/answers/#{answer_id}" }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 4, linkable: answer) }
    let(:answer_json) { json['answer'] }
    
    before do
      answer.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                              filename: 'rails_helper.rb')
      answer.save
    end 

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do

      before { get api_path, params: { access_token: access_token.token } , headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      describe 'links' do
        
        let(:link) { links.first }
        let(:links_json) { answer_json['links'] }
        let(:link_json) { links_json.first }

        it 'returns list of links' do
          expect(links_json.size).to eq 4
        end

        it 'returns all public fields' do
          %w[id linkable_id linkable_type name url created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comments_json) { answer_json['comments'] }
        let(:comment_json) { comments_json.first }

        it 'returns list of comments' do
          expect(comments_json.size).to eq 3
        end

        it 'returns all public fields' do
          %w[id commentable_id commentable_type body user_id created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        
        let(:file) { answer.files.blobs.first }
        let(:files_json) { answer_json['files'] }
        let(:file_json) { files_json.first }

        it 'returns list of files' do
          expect(files_json.size).to eq 1
        end

        it 'returns file url' do
          expect(file_json).to eq rails_blob_url(file, only_path: true)
        end
      end
    end
  end
end
