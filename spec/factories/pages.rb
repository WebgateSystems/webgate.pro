FactoryGirl.define do
  factory :page, aliases: [:en_page] do
    shortlink { Faker::Lorem.word }
    position 1
    title { Faker::Name.title }
    description { Faker::Lorem.paragraph }
    keywords { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
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
