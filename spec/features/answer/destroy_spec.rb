require 'rails_helper'

feature 'User can delete his answer for question', %q{
  In order to delete own answer for question
  as an authenticated User
  I'd like to be able to destroy answer for current question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User deletes his own answer' do
    create(:answer, user: user, question: question)
    sign_in(user)
    visit question_path(question)

    click_on 'Delete answer'
    expect(page).to have_content('Answer was successfully destroyed.')
  end

  scenario 'User tries to find delete-button for another answer' do
    create(:answer, question: question)
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_button('Delete answer')
 end
end
