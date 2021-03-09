FactoryBot.define do
  factory :question do
    association :user
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      association :user
      title { nil }      
    end
  end
end
