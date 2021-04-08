require 'spec_helper'

shared_examples_for "commentable" do
  let(:user) { create(:user) }

  klass_instance = (described_class.new).class.to_s.underscore.to_sym

  case klass_instance
  when :question
    let!(:commentable) { create(klass_instance, user: user) }
  when :answer
    let(:question) { create(:question, user: user) }
    let!(:commentable) { create(klass_instance, user: user, question: question) }
  end
end