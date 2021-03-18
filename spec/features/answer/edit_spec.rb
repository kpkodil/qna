require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  as an author of anwser
  I'd like to be able to edit my answer
} do
  given!(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  scenario 'Unauthenticated user can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    context 'edits his answer' do
      
      before do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'without errors' do      
        click_on 'Edit'

        within '.answers' do
          fill_in :answer_body, with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end 

      scenario 'with errors' do
        click_on 'Edit'

        within '.answers' do
          fill_in :answer_body, with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'with attached files' do
        click_on 'Edit'

        within '.answers' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      context 'deletes attached file' do
        before do
          answer.files.attach(  io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                                filename: 'rails_helper.rb'
                              )
          visit question_path(question)
        end

        scenario 'with deleting any attached file' do        
          click_button 'Delete file'

          expect(page).to_not have_link 'rails_helper.rb'
        end
      end

      context ' via links' do
        before do
          answer.links.build( linkable: question, name: "Example link", url: "http://example.url")
          answer.save
          answer.reload

          visit question_path(question)
        end

        scenario 'with deleting link' do
          within '.answer-links' do
            click_button 'Delete link'

            expect(page).to_not have_link 'Examlple link'
          end
        end

        scenario 'with adding another link' do
          within '.answers' do
            click_link 'Edit'

            fill_in 'Link name', with: "Example link 2"
            fill_in 'Url', with: "http://example2.url"

            click_on 'Save'
          end
          expect(page).to_not have_link 'Examlple link 2'
        end
      end  
    end

    scenario "tries to edit either user's answer" do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
