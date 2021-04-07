require 'rails_helper'
require Rails.root.join "spec/shared/api_authorization.rb"

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json" } }

  let(:access_token) { create(:access_token) }

  let(:user) { create(:user) }

  let!(:questions) { create_list(:question, 2, user: user) }

  let(:question) { questions.first }
  let(:question_id) { question.id }
  let(:question_json) { json['questions'].first }

  let!(:answers) { create_list(:answer, 3, user: user, question: question) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions' do

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
end