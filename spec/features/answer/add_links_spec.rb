require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide aaitional info to my answer
  as an quesiton's author
  I'd like to be able to add links
} do
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:gist_url) { "https://gist.github.com/kpkodil/2fab8b5c571ba048b67d3b8dc1ca7b1f" }

  scenario 'User adds link when give an answer ', js: true do
    sign_in(author)    
    visit question_path(question)

    fill_in 'answer_body', with: 'My answer'

    fill_in 'Link name', with: "My gist"
    fill_in 'Url', with: gist_url

    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url  
    end
  end
end