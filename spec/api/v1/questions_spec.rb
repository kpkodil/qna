require 'rails_helper'

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

  describe 'GET api/v1/questions/question_id' do
    let(:api_path) { "/api/v1/questions/#{question_id}" }
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
          # byebug
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
end