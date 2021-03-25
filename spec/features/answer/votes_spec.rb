require 'rails_helper'

feature 'User can votes for answer', %q{
  In order to like/dislike answers
  as an authenticated user
  I'd like to be able to votes for answers
} do

  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }
  given!(:vote) { create(:vote, vote_value: 1, user: user, votable: answer)}

  scenario 'Unauthenticated can not vote for answers', js: true do
    visit question_path(question)

    within ".answers" do
      click_on '+1'
      expect(page).to_not have_content('User must exist')
    end
  end

  describe 'Authenticated user', js: true do
    scenario "as an answer's author can't vote for own answers" do
      sign_in(author)
      visit question_path(question)

      within ".answers" do
        click_on '+1'
        expect(page).to_not have_content('User can not be an author of votable resource!')
      end
    end

    context "as a non-author" do
      scenario "can vote for answers" do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_content('+1')
        expect(page).to have_content('-1')
      end

      scenario "can delete his vote" do
        sign_in(user)
        visit question_path(question)
        
        within ".answers" do
          click_on 'delete vote'

          within '.rating' do
            expect(page).to have_content('0')
          end
        end
      end
    end
  end
end  