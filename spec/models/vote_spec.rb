require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :vote_value }
  it { should validate_numericality_of(:vote_value).equal?(-1 || 1) }

  let!(:author) { create(:user) }
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:vote) { create(:vote, vote_value: 1, user_id: user.id, votable_type: question.class.to_s, votable_id: question.id ) }

  it { expect(vote).to validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }

  describe 'validate author voting for own resource' do
    subject { Vote.new(vote_value: 1, user: author, votable: question) }
    it { should_not be_valid }
  end
end

