FactoryBot.define do
  sequence :body do |n|
    "Body#{n}"  
  end

  factory :answer do
    user
    question
    body 
    
    trait :invalid do
      user
      question
      body { nil }      
    end
  end
end
