require 'rails_helper'

feature 'User can view question list', %q{
  In order to check  community questions
  as an any User
  I'd like to be able to view question list
} do

  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }

  scenario 'Any users can view questions list' do
    visit questions_path
    
    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end
