FactoryBot.define do
  factory :technology_group do
    title { FFaker::Book.title }
    description { FFaker::Lorem.paragraph }
  end
end
