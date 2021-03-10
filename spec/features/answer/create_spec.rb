require 'rails_helper'

feature 'User can create answer for question', %q{
  In order to answer to question
  as an authenticated User
  I'd like to be able to create answer for current question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates answer with valid params' do
      fill_in 'answer_body', with: 'Answer'
      click_on 'Answer the question'
    
      expect(page).to have_content('Your answer')
      expect(page).to have_button('Answer the question')
    end

    scenario 'creates answer with invalid params' do
      fill_in 'answer_body', with: ''
      click_on 'Answer the question'
      
      expect(page).to have_content('error(s)')
    end 
  end
  
  scenario 'Unauthenticated user tries to create answer on current question page' do
    visit question_path(question)

    fill_in 'answer_body', with: 'Answer'
    click_on 'Answer the question'
    
    expect(page).to have_current_path(new_user_session_path)    
  end
end
