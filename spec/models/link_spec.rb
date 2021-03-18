require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should_not allow_value('invalid').for :url }
  it { should allow_value('http://valid.com').for :url }
end
