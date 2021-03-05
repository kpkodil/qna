require 'rails_helper'

feature 'User can sign out', %q{
  In order to change the account
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit root_path
    click_on 'Log out'
  end

  scenario 'Registered user tries to sign in' do
    expect(page).to have_content 'Signed out successfully.'
  end
end
