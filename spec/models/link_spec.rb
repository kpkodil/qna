require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should_not allow_value('invalid').for :url }
  it { should allow_value('http://valid.com').for :url }


  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe '#a_gist?' do
    
    let!(:link1) { create(:link, name: "A gist", 
                                  url: "https://gist.github.com/kpkodil/2fab8b5c571ba048b67d3b8dc1ca7b1f",
                                  linkable: question) }
    let!(:link2) { create(:link, name: "Not a gist", 
                                  url: "https://blahblahblah.foo",
                                  linkable: question) }

    it 'is a gist when the url is linked to gist' do
      expect(link1.a_gist?).to be_truthy
    end

    it 'is not a gist when the url is not linked to gist' do
      expect(link2.a_gist?).to be_falsey
    end
  end
end
