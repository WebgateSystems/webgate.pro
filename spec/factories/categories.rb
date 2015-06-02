FactoryGirl.define do
  factory :category, aliases: [:en_category] do
    name { Faker::Name.name }
    altlink { Faker::Lorem.word }
    position 1

    factory :pl_category do
      name { Faker::Name.name }
      altlink 'główna'
    end
    factory :ru_category do
      name { Faker::Name.name }
      altlink 'главная'
    end
  end
end
