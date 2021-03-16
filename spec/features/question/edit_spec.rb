require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  as an author of question
  I'd like to be able to edit my question
} do
  given!(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user can not edit questions' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    context 'edits his question' do
      
      before do
        sign_in(author)
        visit questions_path
      end

      scenario 'without errors' do 
        click_on 'Edit'

        within '.questions' do
          fill_in :question_title, with: 'edited question title'
          fill_in :question_body, with: 'edited question body'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to_not have_content question.title
          expect(page).to have_content 'edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end 

      scenario 'with errors' do
        click_on 'Edit'

        within '.questions' do
          fill_in :question_title, with: ''
          fill_in :question_body, with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
          expect(page).to have_content "Title can't be blank"
        end
      end

      scenario 'with attached files' do
        click_on 'Edit'

        within '.questions' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'
        end
        
        click_on question.title

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'with deleting any attached file' do
        question.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                                filename: 'rails_helper.rb'
                              )
        click_on question.title
        
        click_button 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
      
      end
    end

    scenario "tries to edit either user's question" do
      sign_in(user)
      visit questions_path
      expect(page).to_not have_link 'Edit'
    end
  end
end