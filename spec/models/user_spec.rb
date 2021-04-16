require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :rewards }
  it { should have_many(:subscribes).dependent(:destroy) }  
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer,  user: author, question: question ) }

  it "Author is an owner of resource" do
    expect(author).to be_resource_author(question)
  end

  it "User is not an owner of resource" do
    expect(user).not_to be_resource_author(question)
  end

  describe "#subscriber_of?" do
    let(:subscribe) { create(:subscribe, user: user, question: question) }
    let(:unsubscriber) { create(:user) }

    it "User is a aubscriber of question" do
      expect(user).not_to be_subscriber_of(question)
    end

    it "User is an unsubscriber of question" do
      expect(unsubscriber).not_to be_subscriber_of(question)
    end
  end
end
