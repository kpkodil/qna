require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide aaitional info to my answer
  as an quesiton's author
  I'd like to be able to add links
} do
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:example_url)  {"http://example.com"}

  scenario 'Unauthenticated user tries to create answer with link',js: true do
    visit question_path(question)

    fill_in 'Link name', with: "Example"
    fill_in 'Url', with: example_url

    click_on 'Answer the question'

    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  scenario 'User adds link when give an answer', js: true do
    sign_in(author)    
    visit question_path(question)

    fill_in 'answer_body', with: 'My answer'

    fill_in 'Link name', with: "Example link"
    fill_in 'Url', with: example_url

    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_link 'Example link', href: example_url
    end
  end

  scenario 'User can add another link when give an answer ', js: true do
    sign_in(author)    
    visit question_path(question)
    fill_in 'answer_body', with: 'My answer'

    fill_in 'Link name', with: "Example link"
    fill_in 'Url', with: example_url

    click_on 'add link'

    within all(:css, ".nested-fields")[1] do
      fill_in 'Link name', with: "Example link 2"
      fill_in 'Url', with: "http://example2.com"
    end  
    click_on 'Answer the question'

    expect(page).to have_link 'Example link 2', href: "http://example2.com" 
  end  
end