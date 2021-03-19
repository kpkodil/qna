require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to to reward the user for the best answer
  as an quesiton's author
  I'd like to be able to add reward
} do
  given(:author) { create(:user) }
  given(:image_url)  {"https://kassalux.ru/wp-content/uploads/2020/06/%D0%BA%D0%BB%D0%B0%D1%81%D1%81-1024x819-1.png"}

  scenario 'Author adds reward when asks a question' do
    sign_in(author)    
    visit new_question_path
    
    within ".question" do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text test question'
    end

    within ".reward" do
      fill_in 'Reward title', with: "Best answer reward"
      fill_in 'Reward image url', with: image_url      
    end

    click_on 'Ask'

    expect(page).to have_css("img[src*='#{image_url}']")
  end
end