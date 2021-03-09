require 'rails_helper'
feature 'Authenticated user can  answer current question', %q{
  In order to community
  I'd like to be able to answer current question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User can answer the question' do
    sign_in(user)
    
    visit question_path(question)

    expect(page).to have_content 'Your answer'
    expect(page).to have_content attributes_for(:question)[:body]    
    expect(page).to have_content attributes_for(:question)[:title]
    expect(page).to have_button 'Answer the question'
  end
end
