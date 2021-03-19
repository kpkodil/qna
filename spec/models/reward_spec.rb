require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should have_one :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image_url }
  it { should_not allow_value('invalid').for :image_url }
  it { should allow_value('http://valid.com').for :image_url }

  let!(:user) {create(:user) }
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:reward) { create(:reward, question: question) }

  describe '#reward_the_user' do

    it 'rewards the user for the best answer' do
      reward.reward_the_user(user)

      expect(user.rewards.first).to eq reward
    end
  end
end
