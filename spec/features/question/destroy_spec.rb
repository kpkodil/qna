require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete own question
  as an authenticated User
  I'd like to be able to delete my own question
} do

  given!(:author) {create(:user) }
  given!(:user) { create(:user) }

  scenario 'Author deletes his own question' do
    create(:question, user: author)
    sign_in(author)
    visit questions_path

    click_on 'Delete question'

    expect(page).to have_content('Question was successfully destroyed.')
  end

  scenario 'User tries to find delete-link for another question' do
    create(:question, user: author)
    sign_in(user)
    visit questions_path

    expect(page).to_not have_link('Delete question')
 end
end
