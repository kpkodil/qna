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
  describe 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in :comment_body, with: "TestComment"
          click_on 'Comment'
    
          expect(page).to have_content "TestComment"
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "TestComment"
      end
    end
  end
end
