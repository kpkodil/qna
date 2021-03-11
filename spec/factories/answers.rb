FactoryBot.define do

  factory :answer do
    sequence(:body) { |n| "AnswerBody#{n}" }
    
    trait :invalid do
      body { nil }      
    end
  end
end
