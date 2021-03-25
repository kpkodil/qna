require 'spec_helper'

shared_examples_for "votable" do
  let(:user) { create(:user) }

  klass_instance = (described_class.new).class.to_s.underscore.to_sym

  case klass_instance
  when :question
    let!(:votable) { create(klass_instance, user: user) }
  when :answer
    let(:question) { create(:question, user: user) }
    let!(:votable) { create(klass_instance, user: user, question: question) }
  end

  it "has a rating" do
    expect(votable.rating).to eq 0
  end

end