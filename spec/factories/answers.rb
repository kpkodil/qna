FactoryBot.define do
  sequence :body do |n|
    "Answer #{n}"  
  end

  factory :answer do
    user
    question
    body { "AnswerBody" }

    trait :invalid do
      user
      question
      body { nil }      
    end
  end
end
