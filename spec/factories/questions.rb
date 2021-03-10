FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"  
  end

  factory :question do
    user
    title 
    body 

    trait :invalid do
      user
      title { nil }      
    end
  end
end
