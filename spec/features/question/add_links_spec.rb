require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide aaitional info to my question
  as an quesiton's author
  I'd like to be able to add links
} do
  given(:author) { create(:user) }
  given(:example_url)  {"http://example.com"}

  scenario 'User adds link when asks a question' do
    sign_in(author)    
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text test question'

    fill_in 'Link name', with: "Example link"
    fill_in 'Url', with: example_url

    click_on 'Ask'

    expect(page).to have_link 'Example link', href: example_url
  end

  scenario 'User can add another link when asks a question ', js: true do
    sign_in(author)    
    visit new_question_path
    
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text test question'

    fill_in 'Link name', with: "Example link"
    fill_in 'Url', with: example_url

    click_on 'add link'

    within all(:css, ".nested-fields")[1] do
      fill_in 'Link name', with: "Example link 2"
      fill_in 'Url', with: "http://example2.com"
    end  
    click_on 'Ask'

    expect(page).to have_link 'Example link 2', href: "http://example2.com"
  end  
end