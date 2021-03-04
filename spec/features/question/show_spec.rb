require 'rails_helper'

feature 'User can create answer for question', %q{
  In order to answer to question
  as an authenticated User
  I'd like to be able to create answer for current question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates answer on current question page' do
    question = create(:question)
    sign_in(user)
    
    visit question_path(question)
    
    expect(page).to have_content('Your answer')
    expect(page).to have_button('Answer the question')
  end

  scenario 'unauthenticated user tries to create answer on current question page'
end
