require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete own question
  as an authenticated User
  I'd like to be able to delete my own question
} do

  given!(:user) { create(:user) }

  scenario 'User deletes his own question' do
    create(:question, user: user)
    sign_in(user)
    visit questions_path

    click_on 'Delete question'

    expect(page).to have_content('Question was successfully destroyed.')
  end

  scenario 'User tries to find delete-button for another question' do
    create(:question)
    sign_in(user)
    visit questions_path

    expect(page).to_not have_button('Delete answer')
 end
end
