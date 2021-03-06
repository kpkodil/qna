require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  as an authenticated User
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    
    background do
      sign_in(user)
      
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'question text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a quesiton with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  context 'multiple session', js: true do
    scenario "question appears on another user' page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'question text'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'question text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
