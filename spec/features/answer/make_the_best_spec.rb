require 'rails_helper'

feature 'Author of question can one answer as the best', %q{
  In order to mark best answer
  as an author of question
  I'd like to be able to make the answer as the best
} do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer1) { create(:answer, best: true, user: author, question: question) }
  given!(:answer2) { create(:answer, user: author, question: question) }

  scenario "Unauthenticated user can't make the best answers " do
    visit question_path(question)

    expect(page).to_not have_link 'Make the best'
  end

  describe 'Authenticated user', js: true do

    context 'as an author of question' do
      
      before do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'makes one answer as the best' do      
        click_on 'Make the best'

        within '.best-answer' do
          expect(page).to have_content answer2.body
        end
      end 
    end

    context 'as a non-author of question' do
      scenario "tries to make the best answer" do
        sign_in(user)
        visit question_path(question)

        expect(page).to_not have_link 'Make the best'
      end
    end
  end
end