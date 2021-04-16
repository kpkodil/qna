require 'rails_helper'
feature 'Authenticated user can subscribe to current question', %q{
  In order to check new answers 
  as an authenticated user
  I'd like to be able to subscribe to current question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user)}
  given(:question) { create(:question, user: author) }

  describe "Unauthenticated user" do
    scenario 'can not subscribe the question' do
      visit question_path(question)

      expect(page).to_not have_button "Subscribe to this question"
    end
  end
  describe "Authenticated user" do

    before { sign_in(user) }

    context 'as non-subscriber' do
      
      before do
        visit question_path(question)
      end

      scenario 'can subscribe to the question' do
        expect(page).to have_button "Subscribe"
      end
    end

    context 'as a subscriber' do

      before do
        create(:subscribe, user: user, question: question)
      end

      scenario 'can not subscribe to the question' do
        expect(page).to_not have_button "Subscribe"
      end
    end
  end
end