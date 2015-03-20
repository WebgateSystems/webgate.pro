FactoryGirl.define do

  factory :category do
    altlink '/'
    position 1

    factory :pl_category do
      name 'Glowna'
    end
    factory :en_category do
      name 'Main'
    end
    factory :ru_category do
      name 'Главная'
    end
  end
end
