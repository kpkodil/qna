require 'rails_helper'
require Rails.root.join "spec/shared/api_authorization.rb"

describe 'Answers API', type: :request do
  let(:user) { create(:user)}

  let!(:headers) { { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json" } }

  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

  
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer_id) { answer.id }
  let!(:question_id) { question.id }


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

  describe 'POST' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }

    let(:body) { "AnswerBody" }
    let(:link1) { {id: 0, name: "link_name", url: "http://link.com"} } 

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do

      context 'with valid attributes' do
    
        before do 
          post api_path, params: { access_token: access_token.token,
                                   answer: { body: body } },
                                    headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end    

        it 'saves a new answer in the database' do
          expect { post api_path, params: { access_token: access_token.token, answer: { body: body, links: [link1] } }, headers: headers }.to change(Answer, :count).by(1)
        end
      end
      
      context 'with invalid attributes' do
          
        it 'returns 400 status' do
          post api_path, params: { access_token: access_token.token, answer: { body: '', links: [link1] } }, headers: headers 
          expect(response.status).to eq 400
        end       

        it 'do not save a new answer in the database' do
          expect { post api_path, params: { access_token: access_token.token, answer: { body: "", links: [link1] } }, headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/answers/#{answer_id}" }
    
    let!(:new_body) { "NewAnswerBody" }

    let(:link1) { {id: 0, name: "link_name", url: "http://link.com"} } 


    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do

      context 'with valid attributes' do
        before do 
          patch api_path, params: { access_token: access_token.token,
                                    answer: { body: new_body, links: [link1] } },
                                    headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end   

        it 'changes answer attributes' do
          patch api_path, params: { access_token: access_token.token, answer: { body: new_body,links: [link1] } }, headers: headers 
          answer.reload
          expect(answer.body).to eq new_body
        end
      end

      context 'with invalid attributes' do

        it 'returns 400 status' do
          patch api_path, params: { access_token: access_token.token, answer: { body: '', links: [link1] } }, headers: headers
          expect(response.status).to eq 400
        end  

        it 'does not change answer attributes' do
          expect do
            patch api_path, params: { access_token: access_token.token, answer: { body: '', links: [link1] } }, headers: headers 
          end.to_not change(answer, :body)
        end
      end
    end
  end

  describe 'DELETE' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/answers/#{answer_id}" }
    

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do

      context 'User is an author of the answer' do

        it 'returns 200 status' do
          delete api_path, params: { access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end   

        it 'delete the answer from the database' do
          expect{ delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(Answer, :count).by(-1)
        end
      end

      context 'User is not an author of the answer' do
        let(:other) { create(:user) }
        let!(:access_token) { create(:access_token, resource_owner_id: other.id) }

        it 'returns 400 status' do
          delete api_path, params: { access_token: access_token.token }, headers: headers
          expect(response.status).to eq 400
        end  

        it 'does not delete the answer from the database' do
          expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end
end
