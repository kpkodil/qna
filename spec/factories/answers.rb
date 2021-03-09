FactoryBot.define do
  factory :answer do
    association :user
    association :question
    body { "MyText" }

    trait :invalid do
      association :user
      association :question
      body { nil }      
    end
  end
end
