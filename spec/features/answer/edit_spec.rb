require 'rails_helper'

feature 'User can his answer', %q{
  In order to correct mistakes
  as an author of anser
  I'd like to be able to edit my answer
} do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  scenario 'Unauthenticated user can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in(author)
      visit question_path(question)
      
      click_on 'Edit'

      within '.answers' do
        fill_in :answer_body, with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors'
    scenario "tries to edit either user's answer"      
  end
end
