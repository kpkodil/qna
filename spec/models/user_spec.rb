require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it "Can be owner of resource" do
    author = create(:user)
    user = create(:user)
    question = create(:question, user: author)
    answer = create(:answer, user: author, question: question)

    expect(author.is_resource_author?(question)).to be_truthy
    expect(author.is_resource_author?(answer)).to be_truthy

    expect(user.is_resource_author?(question)).to be_falsey
    expect(user.is_resource_author?(answer)).to be_falsey
  end
end
