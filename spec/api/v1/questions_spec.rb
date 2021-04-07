require 'rails_helper'
require Rails.root.join "spec/shared/api_authorization.rb"

describe 'Questions API', type: :request do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  let(:headers) { { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json" } }

  let!(:questions) { create_list(:question, 2, user: user) }

  let(:question) { questions.first }
  let(:question_id) { question.id }
  let(:question_json) { json['questions'].first }

  let!(:answers) { create_list(:answer, 3, user: user, question: question) }
  let(:answer) { answers.first }

  context '/api/v1/questions' do
    describe 'GET' do

      let(:api_path) { '/api/v1/questions' }

      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
      end

      context 'authorized' do

        before { get api_path, params: { access_token: access_token.token } , headers: headers }
        
        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns list of questions' do
          expect(json['questions'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id title body created_at updated_at].each do |attr|
            expect(question_json[attr]).to eq questions.first.send(attr).as_json
          end
        end

        it 'contains user object' do
          expect(question_json['user']['id']).to eq question.user_id
        end

        it 'contains short_title' do
          expect(question_json['short_title']).to eq question.title.truncate(7)
        end

        describe 'answers' do
          
          let(:answer_json) { question_json['answers'].first }

          it 'returns list of answers' do
            expect(question_json['answers'].size).to eq 3
          end

          it 'returns all public fields' do
            %w[id question_id body user_id created_at updated_at].each do |attr|
              expect(answer_json[attr]).to eq answer.send(attr).as_json
            end
          end
        end
      end
    end

    describe 'POST' do
      let(:headers) { { "ACCEPT" => "application/json" } }
      let(:api_path) { '/api/v1/questions' }

      let(:title) { "QuestionTitle" }
      let(:body) { "QuestionBody" }
      let(:link1) { {id: 0, name: "link_name", url: "http://link.com"} } 

      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
      end

      context 'authorized' do

        context 'with valid attributes' do
      
          before do 
            post api_path, params: { access_token: access_token.token,
                                     question: { title: title, body: body } },
                                      headers: headers
          end

          it 'returns 200 status' do
            expect(response).to be_successful
          end    

          it 'saves a new question in the database' do
            expect { post api_path, params: { access_token: access_token.token, question: { title: body, body: body, links: [link1] } }, headers: headers }.to change(Question, :count).by(1)
          end
        end

        context 'with invalid attributes' do
          it 'do not save a new question in the database' do
            expect { post api_path, params: { access_token: access_token.token, question: { title: '', body: body, links: [link1] } }, headers: headers }.to_not change(Question, :count)
          end
        end
      end
    end
  end

  describe "GET /api/v1/questions/question_id/answers" do

    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do

      let(:answers_json) { json['answers'] }
      let(:answer_json) { answers_json.first }

      before do 
        question.reload
        get api_path, params: { access_token: access_token.token } , headers: headers 
      end 
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_json.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id user_id question_id body best created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  context 'api/v1/questions/question_id' do
    let(:api_path) { "/api/v1/questions/#{question_id}" }

    describe 'GET' do
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 4, linkable: question) }
      let(:question_json) { json['question'] }
      
      before do
        question.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                                filename: 'rails_helper.rb')
        question.save
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
          let(:links_json) { question_json['links'] }
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
          let(:comments_json) { question_json['comments'] }
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
          
          let(:file) { question.files.blobs.first }
          let(:files_json) { question_json['files'] }
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

  describe 'PATCH' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    
    let!(:new_title) { "NewQuesitonTitle" }
    let!(:new_body) { "NewQuesitonBody" }

    let(:link1) { {id: 0, name: "link_name", url: "http://link.com"} } 


    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do

      context 'with valid attributes' do
        before do 
          patch api_path, params: { access_token: access_token.token,
                                    question: { title: new_title, body: new_body, links: [link1] } },
                                    headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end   

        it 'changes question attributes' do
          patch api_path, params: { access_token: access_token.token, question: { title: new_title, body: new_body, links: [link1] } }, headers: headers 
          question.reload
          expect(question.body).to eq new_body
        end
      end

      context 'with invalid attributes' do

        it 'does not change answer attributes' do
          expect do
            patch api_path, params: { access_token: access_token.token, question: { title: '', body: '', links: [link1] } }, headers: headers 
          end.to_not change(question, :title)
        end
      end
    end
  end      
  end
end