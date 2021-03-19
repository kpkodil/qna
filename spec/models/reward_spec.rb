require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should have_one :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image_url }
  it { should_not allow_value('invalid').for :image_url }
  it { should allow_value('http://valid.com').for :image_url }

end
