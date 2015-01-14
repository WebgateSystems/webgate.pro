FactoryGirl.define do

  factory :page do  
    shortlink '/'
    position 1

    factory :pl_page do
      association :category, factory: :pl_category
      title 'Glowna'
      description 'Glowna'
      keywords 'Glowna'
      content 'Glowna'
    end

    factory :en_page do
      association :category, factory: :en_category
      title 'Main'
      description 'Main'
      keywords 'Main'
      content 'Main'
    end

    factory :ru_page do
      association :category, factory: :ru_category
      title 'Главная'
      description 'Главная'
      keywords 'Главная'
      content 'Главная'
    end

  end
end