require 'rails_helper'

feature 'User can create answer for question', %q{
  In order to answer to question
  as an authenticated User
  I'd like to be able to create answer for current question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates answer with valid params' do
      fill_in 'answer_body', with: 'Answer'
      click_on 'Answer the question'
    
      expect(page).to have_content 'Your answer'
      expect(page).to have_button 'Answer the question'
    end

    scenario 'creates answer with invalid params' do
      fill_in 'answer_body', with: ''
      click_on 'Answer the question'
    
      expect(page).to have_content 'error(s)'
    end 

    scenario 'creates answer with attached files' do
      fill_in 'answer_body', with: 'Answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer the question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
  
  scenario 'Unauthenticated user tries to create answer on current question page' do
    visit question_path(question)

    fill_in 'answer_body', with: 'Answer'
    click_on 'Answer the question'
    
    expect(page).to have_current_path root_path
  end

  context 'multiple session', js: true do
    scenario "answer appears on another user' page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do

        fill_in 'answer_body', with: 'Test answer'
        click_on 'Answer the question'

        expect(page).to have_content 'Test answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end
end
