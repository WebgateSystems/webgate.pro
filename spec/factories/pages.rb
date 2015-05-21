FactoryGirl.define do

  factory :page do
    shortlink 'about-test'
    position 1

    factory :pl_page do
      association :category, factory: :pl_category
      title 'O nas'
      description 'O nas'
      keywords 'O nas'
      content 'O nas'
    end

    factory :en_page do
      association :category, factory: :en_category
      title 'About us'
      description 'About us'
      keywords 'About us'
      content 'About us'
    end

    factory :ru_page do
      association :category, factory: :ru_category
      title 'О нас'
      description 'О нас'
      keywords 'О нас'
      content 'О нас'
    end

  end
end
