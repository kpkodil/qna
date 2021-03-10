FactoryBot.define do
  factory :question do
    :user
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      :user
      title { nil }      
    end
  end
end
