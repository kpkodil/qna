require 'rails_helper'
require Rails.root.join "spec/shared/api/api_authorization.rb"
require Rails.root.join "spec/shared/api/api_deleteable.rb"
require Rails.root.join "spec/shared/api/api_postable.rb"
require Rails.root.join "spec/shared/api/api_updatable.rb"
require Rails.root.join "spec/shared/api/api_showable.rb"

describe 'Answers API', type: :request do
  let(:user) { create(:user)}

  let!(:headers) { { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json" } }

  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

  
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer_id) { answer.id }
  let!(:question_id) { question.id }
  let(:resource) { answer }

  describe 'GET api/v1/answers/answer_id' do
    let(:api_path) { "/api/v1/answers/#{answer_id}" }

    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 4, linkable: answer) }
    
    before do
      answer.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                              filename: 'rails_helper.rb')
      answer.save
    end 

    let(:resource_json) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API Showable' 
  end

  describe 'POST' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }
    let(:body) { "AnswerBody" }
    let(:links) { [{id: 0, name: "link_name", url: "http://link.com"}] } 

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like "API Postable" do
      let(:title) { nil }
    end
  end

  describe 'PATCH' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/answers/#{answer_id}" }
    
    let!(:new_body) { "NewAnswerBody" }

    let(:new_links) { [{id: 0, name: "link_name", url: "http://link.com"}] } 


    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like "API Updatable" do
      let(:new_title) { nil }
    end
  end

  describe 'DELETE' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/answers/#{answer_id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Deleteable'
  end
end
