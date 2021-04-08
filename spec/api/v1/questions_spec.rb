require 'rails_helper'
require Rails.root.join "spec/shared/api/api_authorization.rb"
require Rails.root.join "spec/shared/api/api_deleteable.rb"
require Rails.root.join "spec/shared/api/api_postable.rb"
require Rails.root.join "spec/shared/api/api_updatable.rb"
require Rails.root.join "spec/shared/api/api_showable.rb"

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
  let(:resource) { question }

  context '/api/v1/questions' do
    
    let(:api_path) { '/api/v1/questions' }

    describe 'GET' do

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

      let(:title) { "QuestionTitle" }
      let(:body) { "QuestionBody" }
      let(:links) { [{id: 0, name: "link_name", url: "http://link.com"}] } 

      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
      end

      it_behaves_like "API Postable" 
    end
  end

  context "/api/v1/questions/question_id/answers" do
    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }
    describe "GET" do
      
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
  end

  context 'api/v1/questions/question_id' do
    let(:api_path) { "/api/v1/questions/#{question_id}" }

    describe 'GET' do
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 4, linkable: question) }
      let(:resource_json) { json['question'] }
      
      before do
        question.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                                filename: 'rails_helper.rb')
        question.save
      end 

      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
      end

      it_behaves_like 'API Showable'
    end

    describe 'PATCH' do
      let(:headers) { { "ACCEPT" => "application/json" } }
      
      let!(:new_title) { "NewQuestionTitle" }
      let!(:new_body) { "NewQuestionBody" }
      let!(:new_links) { [{id: 0, name: "link_name", url: "http://link.com"}] } 


      it_behaves_like 'API Authorizable' do
        let(:method) { :patch }
      end

      it_behaves_like "API Updatable"
    end

    describe 'DELETE' do
      let(:headers) { { "ACCEPT" => "application/json" } }

      it_behaves_like 'API Authorizable' do
        let(:method) { :delete }
      end

      it_behaves_like 'API Deleteable'
    end
  end
end