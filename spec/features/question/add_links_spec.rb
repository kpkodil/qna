require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide aaitional info to my question
  as an quesiton's author
  I'd like to be able to add links
} do
  given(:author) { create(:user) }
  given(:gist_url) { "https://gist.github.com/kpkodil/2fab8b5c571ba048b67d3b8dc1ca7b1f" }

  scenario 'User adds link when asks question' do
    sign_in(author)    
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text test question'

    fill_in 'Link name', with: "My gist"
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end