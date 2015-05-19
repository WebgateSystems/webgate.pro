FactoryGirl.define do

  factory :page, aliases: [:en_page] do
    title 'About us'
    description 'About us'
    keywords 'About us'
    content 'About us'
    shortlink 'about-test'
    position 1
    category

    factory :pl_page do
      association :category, factory: :pl_category
      title 'O nas'
      description 'O nas'
      keywords 'O nas'
      content 'O nas'
      shortlink 'pl-about-test'
    end

    factory :ru_page do
      association :category, factory: :ru_category
      title 'О нас'
      description 'О нас'
      keywords 'О нас'
      content 'О нас'
      shortlink 'о-нас'
    end

  end
end
