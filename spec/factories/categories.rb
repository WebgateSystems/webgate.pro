FactoryBot.define do
  factory :category, aliases: [:en_category] do
    name { FFaker::Lorem.characters(10) }
    altlink { FFaker::Lorem.word }
    position { 1 }

    factory :pl_category do
      name { FFaker::Lorem.characters(10) }
      altlink { 'główna' }
    end

    factory :ru_category do
      name { FFaker::Lorem.characters(10) }
      altlink { 'главная' }
    end
  end
end
