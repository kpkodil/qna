require 'rails_helper'

feature 'User can votes for question', %q{
  In order to like/dislike questions
  as an authenticated user
  I'd like to be able to votes for questions
} do

  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:vote) { create(:vote, vote_value: 1, user: user, votable: question)}

  scenario 'Unauthenticated can not vote for questions', js: true do
    visit question_path(question)

    within ".question" do
      click_on '+1'
      expect(page).to_not have_content('User must exist')
    end
  end

  describe 'Authenticated user', js: true do
    scenario "as an question's author can't vote for own question" do
      sign_in(author)
      visit question_path(question)

      within ".question" do
        click_on '+1'
        expect(page).to_not have_content('User can not be an author of votable resource!')
      end
    end

    context "as a non-author" do
      scenario "can vote for questions" do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_content('+1')
        expect(page).to have_content('-1')
      end

      scenario "can delete his vote" do
        vote.reload
        
        sign_in(user)
        visit question_path(question)


        within ".question" do
          click_on 'delete vote'

          within '.rating' do
            expect(page).to have_content('0')
          end
        end
      end
    end
  end
end  