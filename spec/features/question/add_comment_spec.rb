require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to discuss question
  as an authenticated user
  I'd like to be able to add comments 
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user tries to create comment',js: true do
    visit question_path(question)
    within(".question") do
      expect(page).to_not have_field("Your comment")
    end
  end

  describe 'User adds comment', js: true do
    scenario 'with valid params' do |variable|
      sign_in(user)    
      visit question_path(question)

      within(".question") do
        fill_in 'Your comment', with: 'My comment'
        click_on "Comment"
        expect(page).to have_content("My comment")
      end
    end

    scenario 'with invalid params' do |variable|
      sign_in(user)    
      visit question_path(question)

      within(".question") do
        fill_in 'Your comment', with: ''
        click_on "Comment"
        expect(page).to have_content("error(s)")
      end
    end
  end
end
