require 'rails_helper'

RSpec.describe RewardOwning, type: :model do
  it { should belong_to :user }
  it { should belong_to :reward }
end
