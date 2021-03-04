require 'rails_helper'

feature 'User can view question list', %q{
  In order to check  community questions
  as an any User
  I'd like to be able to view question list
} do

  scenario 'Any users can view questions list' do
    visit questions_path

    expect(page).to have_content "Questions list"
    expect(page).to have_content "Title"
  end
end
