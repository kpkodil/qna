require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions and answer questions
  As an unregistred user
  I'd like to be able to sign up 
} do

  background do
    visit root_path
    click_on 'Sign up'
  end

  scenario 'Unregistred user tries to register with valid params' do

    fill_in 'Email', with: attributes_for(:user)[:email]
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password]
    click_button 'Sign up'
    
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistred user tries to register with invalid params' do 
    fill_in 'Email', with: ''
    fill_in 'Password', with: attributes_for(:user)[:password]
    fill_in 'Password confirmation', with: attributes_for(:user)[:password]
    click_button 'Sign up'
    
    expect(page).to have_content ('error' || 'errors')
  end
end
