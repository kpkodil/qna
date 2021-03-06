require 'rails_helper'
feature 'Authenticated user can  answer current question', %q{
  In order to community
  I'd like to be able to answer current question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2,  user: user, question: question ) }

  scenario 'User can answer the question' do
    sign_in(user)

    visit question_path(question)

    answers.each do |ans|
      expect(page).to have_content ans.body
    end
  end
end
