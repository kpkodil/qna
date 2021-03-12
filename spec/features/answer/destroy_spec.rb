require 'rails_helper'

feature 'User can delete his answer for question', %q{
  In order to delete own answer for question
  as an authenticated User
  I'd like to be able to destroy answer for current question
} do

  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }
  
  scenario 'Unauthenticated user tries to find delete-link for any answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer' 
  end

  describe 'Authenticated user', js: true do

    scenario  'as an author deletes his answer' do
      sign_in(author)
      visit question_path(question)

      click_on 'Delete answer'
      accept_alert

      expect(page).not_to have_content answer.body
    end 

    scenario "as a non-author tries to delete either user's answer" do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_link 'Delete answer'        
    end
  end
end
