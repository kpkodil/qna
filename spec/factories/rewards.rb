FactoryBot.define do
  factory :reward do
    sequence(:title) { |n| "Reward title#{n}" }
    sequence(:image_url) { |n| "http://image#{n},com" }
  end
end
