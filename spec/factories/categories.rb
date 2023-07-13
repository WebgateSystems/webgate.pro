FactoryBot.define do
  factory :category, aliases: [:en_category] do
    name { FFaker::Name.name }
    altlink { FFaker::Lorem.word }
    position { 1 }

    factory :pl_category do
      name { FFaker::Name.name }
      altlink { 'główna' }
    end

    factory :ru_category do
      name { FFaker::Name.name }
      altlink { 'главная' }
    end
  end
end
